/*
 * Gramatica da linguagem LA.
 *
 * Grupo:
 * Arieh Cangiani Fabbro
 * Felipe Fantoni
 * Lucas Hauptmann Pereira 
 * Lucas Oliveira David
*/

grammar La;

@members{ //Cria um objeto pilhaDeTabelas 
    infrastructure.PilhaDeTabelas pilhaDeTabelas = new infrastructure.PilhaDeTabelas();
}

programa
    : {pilhaDeTabelas.empilhar(new infrastructure.TabelaDeSimbolos("global"));}
      declaracoes 'algoritmo' corpo 'fim_algoritmo'
      {pilhaDeTabelas.desempilhar();}
    ;

declaracoes
    : decl_local_global*
    ;

decl_local_global
    : declaracao_local
    | declaracao_global
    ;

declaracao_local
    : 'declare' variavel
    | 'constante' IDENT 
      ':' tipo_basico 
      {
          pilhaDeTabelas.topo().adicionarSimbolo($IDENT.getText(), "constante", $tipo_basico.nomeTipo);
      }
      '=' valor_constante
    | 'tipo' IDENT ':' tipo
    ;

variavel 
    : { java.util.List<String> vars = new java.util.ArrayList<String>(); }
      IDENT
      {
         String varASerComparada = $IDENT.getText();
         
			         
         if(vars.contains(varASerComparada)) {
            infrastructure.Mensagens.erroVariavelJaExiste($IDENT.line, varASerComparada);
	} else {
             vars.add(varASerComparada);
        }
      }
      dimensao (',' IDENT 
      {
         varASerComparada = $IDENT.getText();
         if(vars.contains(varASerComparada)) {
            infrastructure.Mensagens.erroVariavelJaExiste($IDENT.line, varASerComparada);
	} else {
             vars.add(varASerComparada);
        }
      }
      dimensao)*
      ':' tipo
      {
         for (String varDaLista:vars) {
            pilhaDeTabelas.topo().adicionarSimbolo(varDaLista, "variavel", $tipo.nomeTipo);
         }
      }
    ;

identificador
    : ponteiros_opcionais IDENT 
      {
          if (!pilhaDeTabelas.existeSimbolo($IDENT.getText())) {
               infrastructure.Mensagens.erroVariavelNaoExiste($IDENT.line,$IDENT.getText());
          }
      }
      ('.' IDENT
      {
          if (!pilhaDeTabelas.existeSimbolo($IDENT.getText())) {
               infrastructure.Mensagens.erroVariavelNaoExiste($IDENT.line,$IDENT.getText());
          }
      }
      )*
      dimensao outros_ident
      //: ponteiros_opcionais IDENT ('.' IDENT)* dimensao
    ;

ponteiros_opcionais
    : '^'*
    ;
 
outros_ident
    : ('.' identificador)?
    ;

dimensao
    : ('[' exp_aritmetica ']' dimensao)?
    ;

tipo returns [ String nomeTipo ]
    : registro { $nomeTipo = "registro"; }
    | tipo_estendido { $nomeTipo = "int"; }
    ;

tipo_estendido
    : ponteiros_opcionais tipo_basico_ident
    ;

mais_ident
    : (',' identificador mais_ident)?
    ;

mais_variaveis
    : (variavel mais_variaveis)?
    ;

tipo_basico returns [ String nomeTipo, int linha ]
    : 'literal' { $nomeTipo = "literal"; }
    | 'inteiro' { $nomeTipo = "inteiro"; }
    | 'real' { $nomeTipo = "real"; }
    | 'logico' { $nomeTipo = "logico"; }
    ;

tipo_basico_ident returns [ String nomeTipo ]
    : tipo_basico { $nomeTipo = $tipo_basico.nomeTipo; }
    | IDENT { $nomeTipo = $IDENT.getText(); }
    ;

valor_constante
    : CADEIA
    | NUM_INT
    | NUM_REAL
    | 'verdadeiro'
    | 'falso'
    ;

registro
    : 'registro' variavel* mais_variaveis 'fim_registro'
    ;

declaracao_global
    : { pilhaDeTabelas.empilhar(new infrastructure.TabelaDeSimbolos("procedimento")); }
      'procedimento' IDENT
     /*  {   //Nao tenho certeza
          if (!pilhaDeTabelas.existeSimbolo($IDENT.getText())) {
              Mensagens.erroVariavelJaExiste($IDENT.line,$IDENT.getText());
          }
          else {
              pilhaDeTabelas.topo().adicionarSimbolo($IDENT.getText(), "procedimento");
          }
      }  */
      '(' parametros_opcional ')' declaracoes_locais comandos 'fim_procedimento'
      { pilhaDeTabelas.desempilhar(); }
    | { pilhaDeTabelas.empilhar(new infrastructure.TabelaDeSimbolos("funcao")); }
      'funcao' IDENT
    /*  {   //Nao tenho certeza
          if (!pilhaDeTabelas.existeSimbolo($IDENT.getText())) {
              Mensagens.erroVariavelJaExiste($IDENT.line,$IDENT.getText());
          }
          else {
              pilhaDeTabelas.topo().adicionarSimbolo($IDENT.getText(), "funcao");
          }
      }  */
      '(' parametros_opcional '):' tipo_estendido declaracoes_locais comandos 'fim_funcao'
      { pilhaDeTabelas.desempilhar(); }
    ;

parametros_opcional
    : (parametro)?
    ;

parametro
    : var_opcional identificador mais_ident ':' tipo_estendido (',' parametro)?
    ;

var_opcional
    : 'var'?
    ;

declaracoes_locais
    : (declaracao_local declaracoes_locais)?
    ;

corpo
    : declaracoes_locais comandos
    ;

comandos
    : (cmd comandos)?
    ;

cmd 
    : 'leia' '(' identificador mais_ident ')'
    | 'escreva' '(' expressao mais_expressao ')'
    | 'se' expressao 'entao' comandos senao_opcional 'fim_se'
    | 'caso' exp_aritmetica 'seja' selecao senao_opcional 'fim_caso'
    | 'para'
      {   //Empilha (Cria) um novo escopo para o FOR
          pilhaDeTabelas.empilhar(new infrastructure.TabelaDeSimbolos("para"));
      }
      IDENT 
      {   //Lanca um erro quando nao encontra a variavel na pilha de tabelas
          if (!pilhaDeTabelas.existeSimbolo($IDENT.getText())) {
               infrastructure.Mensagens.erroVariavelNaoExiste($IDENT.line,$IDENT.getText());
          }
      }
      '<-' exp_aritmetica 'ate' exp_aritmetica 'faca' comandos 'fim_para'
      {   //Desempilha o escopo do FOR
          pilhaDeTabelas.desempilhar();
      }
    | 'enquanto' expressao 'faca' comandos 'fim_enquanto'
    | 'faca' comandos 'ate' expressao
    | '^' IDENT outros_ident dimensao '<-' expressao
    | IDENT chamada_atribuicao
    | RETORNAR expressao
      {
         String escopo = pilhaDeTabelas.topo().getEscopo();
         if (!escopo.equals("funcao"))
            infrastructure.Mensagens.escopoProibido($RETORNAR.line);
      }
    ;

mais_expressao
    : (',' expressao mais_expressao)?
    ;

senao_opcional
    : ('senao' comandos)?
    ;

chamada_atribuicao
    : '(' argumentos_opcional ')'
    | outros_ident dimensao '<-' expressao
    ;

argumentos_opcional
    : (expressao mais_expressao)?
    ;

selecao
    : constantes ':' comandos mais_selecao
    ;

mais_selecao
    : (selecao)?
    ;

constantes
    : numero_intervalo mais_constantes
    ;

mais_constantes
    : (',' constantes)?
    ;
numero_intervalo
    : op_unario NUM_INT intervalo_opcional
    ;

intervalo_opcional
    : ('..' op_unario NUM_INT)?
    ;

op_unario
    : '-'?
    ;

exp_aritmetica
    : termo outros_termos
    ;

op_multiplicacao
    : '*'
    | '/'
    ;

op_adicao
    : '+'
    | '-'
    ;

termo
    : fator outros_fatores
    ;

outros_termos
    : (op_adicao termo outros_termos)?
    ;

fator
    : parcela outras_parcelas
    ;

outros_fatores
    : (op_multiplicacao fator outros_fatores)?
    ;

parcela
    : op_unario parcela_unario
    | parcela_nao_unario
    ;

parcela_unario
    : '^' IDENT 
      {
         if (!pilhaDeTabelas.existeSimbolo($IDENT.getText())) {
            infrastructure.Mensagens.erroVariavelNaoExiste($IDENT.line,$IDENT.getText());
         }
      }
      outros_ident dimensao
    | IDENT 
      {
         if (!pilhaDeTabelas.existeSimbolo($IDENT.getText())) {
            infrastructure.Mensagens.erroVariavelNaoExiste($IDENT.line,$IDENT.getText());
         }
      }
      outros_ident dimensao
    | IDENT 
      {
         if (!pilhaDeTabelas.existeSimbolo($IDENT.getText())) {
            infrastructure.Mensagens.erroVariavelNaoExiste($IDENT.line,$IDENT.getText());
         }
      }
      '(' expressao mais_expressao ')'
    | NUM_INT
    | NUM_REAL
    | '(' expressao ')'
    ;

parcela_nao_unario
    : '&' IDENT
      {
         if (!pilhaDeTabelas.existeSimbolo($IDENT.getText())) {
            infrastructure.Mensagens.erroVariavelNaoExiste($IDENT.line,$IDENT.getText());
         }
      }
      outros_ident dimensao
    | CADEIA
    ;

outras_parcelas
    : ('%' parcela outras_parcelas)?
    ;

op_opcional
    : (op_relacional exp_aritmetica)?
    ;

op_relacional
    : '='
    | '<>'
    | '>=' 
    | '<=' 
    | '>' 
    | '<'
    ;

expressao
    : termo_logico outros_termos_logicos
    ;

outros_termos_logicos
    : ('ou' termo_logico outros_termos_logicos)?
    ;

termo_logico
    : fator_logico outros_fatores_logicos
    ;

outros_fatores_logicos
    : ('e' fator_logico outros_fatores_logicos)?
    ;

fator_logico
    : op_nao parcela_logica
    ;

op_nao
    : ('nao')?
    ;

parcela_logica 
    : 'verdadeiro'
    | 'falso'
    | exp_relacional
    ;

exp_relacional
    : exp_aritmetica op_opcional
    ;

RETORNAR
    : 'retorne'
    ;

IDENT
    : ('a'..'z' | 'A'..'Z' | '_') ('a'..'z' | 'A'..'Z' | '0'..'9' | '_')*
    ;

CADEIA
    : '"' ~('\n' | '\r' | '"')* '"'
    ;

NUM_INT
    : ('0'..'9')+
    ;

NUM_REAL
    : ('0'..'9')+ '.' ('0'..'9')+
    // | '.' ('0'..'9')+
    ;

COMENTARIO
    : '{' ~('\n' | '\r' | '}')* '}' {skip();}
    ;

WS
    : (' ' | '\t' | '\r' | '\n') {skip();}
    ;

