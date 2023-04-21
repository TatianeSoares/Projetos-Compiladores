%option noyywrap
%x comment

%{
    #include <stdio.h>
    #include <string.h>

    int coluna = 0;
    int linhas = 1;
    int estadoInicial = 0;
    int linhaComentario = 0;
    int linhaComentarioInicial = 0;
    int colunaComentario = 0;

    void quebraLinha(){
        if(estadoInicial == 1)
        {
            printf("\n");
        }
        else
        {
            estadoInicial++;
        }
    }
%}


%%

"void"             {quebraLinha(); printf("VOID"); coluna+=strlen(yytext);}
"int"              {quebraLinha(); printf("INT"); coluna+=strlen(yytext);}
"char"             {quebraLinha(); printf("CHAR"); coluna+=strlen(yytext);}
"return"           {quebraLinha(); printf("RETURN"); coluna+=strlen(yytext);}
"break"            {quebraLinha(); printf("BREAK"); coluna+=strlen(yytext);}
"switch"           {quebraLinha(); printf("SWITCH"); coluna+=strlen(yytext);}
"case"             {quebraLinha(); printf("CASE"); coluna+=strlen(yytext);}
"default"          {quebraLinha(); printf("DEFAULT"); coluna+=strlen(yytext);}
"do"               {quebraLinha(); printf("DO"); coluna+=strlen(yytext);}
"while"            {quebraLinha(); printf("WHILE"); coluna+=strlen(yytext);}
"for"              {quebraLinha(); printf("FOR"); coluna+=strlen(yytext);}
"if"               {quebraLinha(); printf("IF"); coluna+=strlen(yytext);}
"else"             {quebraLinha(); printf("ELSE"); coluna+=strlen(yytext);}
"typedef"          {quebraLinha(); printf("TYPEDEF"); coluna+=strlen(yytext);}
"struct"           {quebraLinha(); printf("STRUCT"); coluna+=strlen(yytext);}


"+"                {quebraLinha(); printf("PLUS"); coluna+=strlen(yytext);}
"-"                {quebraLinha(); printf("MINUS"); coluna+=strlen(yytext);}
"*"                {quebraLinha(); printf("MULTIPLY"); coluna+=strlen(yytext);}
"/"                {quebraLinha(); printf("DIV"); coluna+=strlen(yytext);}
"%"                {quebraLinha(); printf("REMAINDER"); coluna+=strlen(yytext);}
"++"               {quebraLinha(); printf("INC"); coluna+=strlen(yytext);}
"--"               {quebraLinha(); printf("DEC"); coluna+=strlen(yytext);}
"&"                {quebraLinha(); printf("BITWISE_AND"); coluna+=strlen(yytext);}
"|"                {quebraLinha(); printf("BITWISE_OR"); coluna+=strlen(yytext);}
"~"                {quebraLinha(); printf("BITWISE_NOT"); coluna+=strlen(yytext);}
"^"                {quebraLinha(); printf("BITWISE_XOR"); coluna+=strlen(yytext);}
"!"                {quebraLinha(); printf("NOT"); coluna+=strlen(yytext);}
"&&"               {quebraLinha(); printf("LOGICAL_AND"); coluna+=strlen(yytext);}
"||"               {quebraLinha(); printf("LOGICAL_OR"); coluna+=strlen(yytext);}
"=="               {quebraLinha(); printf("EQUAL"); coluna+=strlen(yytext);}
"!="               {quebraLinha(); printf("NOT_EQUAL"); coluna+=strlen(yytext);}
"<"                {quebraLinha(); printf("LESS_THAN"); coluna+=strlen(yytext);}
">"                {quebraLinha(); printf("GREATER_THAN"); coluna+=strlen(yytext);}
"<="               {quebraLinha(); printf("LESS_EQUAL"); coluna+=strlen(yytext);}
">="               {quebraLinha(); printf("GREATER_EQUAL"); coluna+=strlen(yytext);}
">>"               {quebraLinha(); printf("R_SHIFT"); coluna+=strlen(yytext);}
"<<"               {quebraLinha(); printf("L_SHIFT"); coluna+=strlen(yytext);}
"="                {quebraLinha(); printf("ASSIGN"); coluna+=strlen(yytext);}
"+="               {quebraLinha(); printf("ADD_ASSIGN"); coluna+=strlen(yytext);}
"-="               {quebraLinha(); printf("MINUS_ASSIGN"); coluna+=strlen(yytext);}
";"                {quebraLinha(); printf("SEMICOLON"); coluna+=strlen(yytext);}
","                {quebraLinha(); printf("COMMA"); coluna+=strlen(yytext);}
":"                {quebraLinha(); printf("COLON"); coluna+=strlen(yytext);}
"("                {quebraLinha(); printf("L_PAREN"); coluna+=strlen(yytext);}
")"                {quebraLinha(); printf("R_PAREN"); coluna+=strlen(yytext);}
"{"                {quebraLinha(); printf("L_CURLY_BRACKET"); coluna+=strlen(yytext);}
"}"                {quebraLinha(); printf("R_CURLY_BRACKET"); coluna+=strlen(yytext);}
"["                {quebraLinha(); printf("L_SQUARE_BRACKET"); coluna+=strlen(yytext);}
"]"                {quebraLinha(); printf("R_SQUARE_BRACKET"); coluna+=strlen(yytext);}
"?"                {quebraLinha(); printf("TERNARY_CONDITIONAL"); coluna+=strlen(yytext);}
"#"                {quebraLinha(); printf("NUMBER_SIGN"); coluna+=strlen(yytext);}
"->"               {quebraLinha(); printf("POINTER"); coluna+=strlen(yytext);}


"printf"           {quebraLinha(); printf("PRINTF"); coluna+=strlen(yytext);}
"scanf"            {quebraLinha(); printf("SCANF"); coluna+=strlen(yytext);}
"define"           {quebraLinha(); printf("DEFINE"); coluna+=strlen(yytext);}
"exit"             {quebraLinha(); printf("EXIT"); coluna+=strlen(yytext);}


" "                {coluna++;} 


[\n]               {linhas++; coluna = 1;}
[\t]               {coluna+=strlen(yytext);}
[\r]               {coluna+=strlen(yytext);}
[\f]               {coluna+=strlen(yytext);}


[_a-zA-Z][_a-zA-Z0-9]* { 
    quebraLinha();

    if(strlen(yytext)>255)
    {
        printf("error:lexical:%d:%d: identifier too long", linhas, coluna);
    }
    else
    {
        printf("IDENTIFIER(%s)", yytext);
    }
    coluna += strlen(yytext);
}
 
(\")([^"\\]|[\\.]|\\[\"])*(\") {
    quebraLinha();
    char auxString[strlen(yytext)-2];
    for(int i = 1; i < strlen(yytext)-1; i++)
    {
        auxString[i-1] = yytext[i];
        auxString[i] = '\0';
    }

    printf("STRING(%s)", auxString); 
    coluna += strlen(yytext);
} 

[\'][\\]?([^']|(.))[\'] {
    quebraLinha();
    if(strlen(yytext) <= 3)
    {
        printf("CHARACTER(%c)", yytext[1]);
    }
    else
    {
        printf("CHARACTER(%c%c)", yytext[1], yytext[2]);
    }    
    coluna += strlen(yytext);
}

0([x]|[X])[0-9a-fA-F]+ {
    quebraLinha();
    printf("NUM_HEXA(%s)", yytext);
    coluna += strlen(yytext);
}

"0"[1-7][0-7]* {
    quebraLinha();
    printf("NUM_OCTAL(%s)", yytext);
    coluna += strlen(yytext);
}

[0-9]+ {
    quebraLinha();
    printf("NUM_INTEGER(%s)", yytext);
    coluna += strlen(yytext);
}

"//".*\n {
    linhas++; 
    coluna = 1;
}

"/*" { 
    BEGIN(comment);
    colunaComentario = coluna; 
    linhaComentarioInicial =linhas;
    coluna += strlen(yytext);  
}
<comment>"*/" { 
    BEGIN(INITIAL);
    coluna += strlen(yytext);
    linhaComentarioInicial = 0;
    colunaComentario = 1;   
}  
<comment>\n {
    linhas++;
    coluna = 1;
}
<comment>([^*])+|. {
    for(int i = 0; i < strlen(yytext); i++)
    {
        if(yytext[i] == '\n')
        {
            linhas++;
            coluna = 0;
        }
        coluna++;
    }
}
<comment>[\\/*][^*/\\] {
    quebraLinha();
    printf("warning:%d:%d: '/*' within block comment", linhas, coluna-1);
    for(int i = 0; i < strlen(yytext); i++)
    {
        if(yytext[i] == '\n')
        {
            linhas++;
            coluna = 0;
        }
        coluna++;
    }
}
<comment><<EOF>> {  
    BEGIN(INITIAL);
    quebraLinha(); 
    printf("error:lexical:%d:%d: unterminated comment", linhaComentarioInicial, colunaComentario); 
    return 0;
}      

. {
    quebraLinha();
    printf("error:lexical:%d:%d: %s", linhas, coluna, yytext);
    coluna += strlen(yytext);
}

%%


int main(int argc, char **argv)
{
    yylex();
    return 0;
}


