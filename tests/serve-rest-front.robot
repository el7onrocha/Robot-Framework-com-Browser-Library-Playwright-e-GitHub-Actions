*** Settings ***

Resource  ../resources/serve-rest-front.resource



*** Test Cases ***

Desafio 01 : Automatizar um teste do zero
    [Tags]    desafio01
    Dado que eu esteja na pagina de login da Serve Rest Front
    Quando realizo o cadastro de um novo usuario 
    Entao o novo usuario devera aparecer na listagem 

Desafio 02 : Desenvolva um teste para cadastrar e consultar produto
    Dado que eu esteja na pagina de cadastrar produto
    Quando realizo o cadastro de um novo produto 
    Entao o novo produto devera aparecer na listagem 

Desafio 03 : Acessar a pagina logando pelo back via API
    [Tags]    desafio03
    Dado que eu esteja na pagina Serve Rest Front logado via API
    #Quando realizo o cadastro de um novo produto 
    #Entao o novo produto devera aparecer na listagem 