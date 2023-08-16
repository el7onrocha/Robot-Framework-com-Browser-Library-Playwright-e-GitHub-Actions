*** Settings ***

Resource  ../resources/hooks.resource


*** Keywords ***

Dado que eu esteja na pagina de login da Serve Rest Front
    Abrir o navegador
    Ir para o site Serve Rest Front

Quando realizo o cadastro de um novo usuario 
    Preencher os dados do novo usuário e cadastrar
    Checar se o usuario ja é cadastrado
    Click    css=a[data-testid='listarUsuarios']
Entao o novo usuario devera aparecer na listagem
    Conferir usuário cadastrado com sucesso

Dado que eu esteja na pagina de cadastrar produto
    Abrir o navegador
    Ir para o site Serve Rest Front
    Preencher os dados do novo usuário e cadastrar
    Checar se o usuario ja é cadastrado
    Click    //a[@data-testid='cadastrarProdutos'][contains(.,'Cadastrar')]

Quando realizo o cadastro de um novo produto
    Cadastrar novo produto

Dado que eu esteja na pagina Serve Rest Front logado via API
    Abrir o navegador
    Logar com o usuário cadastrado via API
    #Logar com o usuário cadastrado via API

Ir para o site Serve Rest Front
    New Page        url=${SITE_SERVE_REST}
    ${title}        Get Title  ==  Front - ServeRest
    Log  ${title}

Preencher os dados do novo usuário e cadastrar
    Click             css=a[data-testid='cadastrar']
    Fill Text         css=input[data-testid='nome']       Elton Rocha
    Fill Text         css=input[data-testid='email']      ${EMAIL}
    Fill Text         css=input[data-testid='password']   123456
    Check Checkbox    css=input[data-testid='checkbox']
    Click             xpath=//*[@id="root"]//button >> text="Cadastrar"

Checar se o usuario ja é cadastrado
    ${email_ja_cadastrado}     Run Keyword And Return Status    Wait For Elements State   //span[contains(.,'Este email já está sendo usado')]
    IF    ${email_ja_cadastrado} == True
        Scroll To     //a[@data-testid='entrar'][contains(.,'Entrar')]
        Click         //a[@data-testid='entrar'][contains(.,'Entrar')]
        Fill Text     css=input[data-testid='email']      ${EMAIL}
        Fill Text     //input[contains(@name,'password')]   123456
        Click         //button[@data-testid='entrar'][contains(.,'Entrar')]
    ELSE
        Click         //button[@data-testid='cadastrar'][contains(.,'Cadastrar')]
    END
    
Conferir usuário cadastrado com sucesso
    Get Text    h1    ==   Lista dos usuários
    Scroll To Element      //td[contains(.,'eltonrocha@outlook.com')]
    Get Element States     //td[contains(.,'eltonrocha@outlook.com')]   validate  value & visible
    ${elemento}      Get Table Cell Element    css=table    "Nome"    "${EMAIL}"
    ${usuario_nome}  Get Text  ${elemento}  ==  Elton Rocha
    Highlight Elements    ${elemento}
    Take Screenshot       fullPage=${true}  

Cadastrar novo produto
    Fill Text                   //input[contains(@name,'nome')]    ${produto}
    Fill Text                   //input[contains(@name,'price')]    5000
    Fill Text                   //textarea[contains(@name,'description')]  Notebook core17 32gb com placa de vídeo integrada  
    Fill Text                   //input[contains(@name,'quantity')]  100
    Scroll To Element           //button[@data-testid='cadastarProdutos'][contains(.,'Cadastrar')]
    Upload File By Selector     //input[contains(@name,'imagem')]    laptop.jpg
    Click                       //button[@data-testid='cadastarProdutos'][contains(.,'Cadastrar')]
    ${produto_ja_cadastrado}     Run Keyword And Return Status    Wait For Elements State   //span[contains(.,'Já existe produto com esse nome')]
    IF    ${produto_ja_cadastrado} == True
        Click         //a[@data-testid='listar-produtos'][contains(.,'Listar Produtos')]
    ELSE
        Click         //button[@data-testid='cadastarProdutos'][contains(.,'Cadastrar')]
    END
    
Entao o novo produto devera aparecer na listagem
    Get Text    h1    ==   Lista dos Produtos
    ${produto}       Get Table Cell Element    css=table     "Nome"    "${produto}"
    ${produto_nome}  Get Text  ${produto}  ==  Notebook
    Highlight Elements    ${produto}
    Take Screenshot       fullPage=${true}
