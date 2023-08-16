*** Settings ***

Library   Browser
# ...      timeout=00:00:05
# ...      enable_presenter_mode=${true}
Library   DebugLibrary
Library   FakerLibrary
Library   DateTime

*** Variables ***
${BROWSER}                               chromium
${HEADLESS}                              ${false}
${SITE_SERVE_REST}                       https://front.serverest.dev/
${EMAIL}                                 eltonrocha@outlook.com
${produto}                               Notebook

*** Keywords ***

Abrir o navegador
    New Browser    browser=${BROWSER}
    ...            headless=${HEADLESS}
    ${TRACE_NAME}  FakerLibrary.Uuid 4
    ${NOW}         Get Current Date  result_format=%d-%m-%Y_%H%M%S
    New Context    viewport={'width': 1366, 'height': 768}
    # ...            tracing=${OUTPUT_DIR}/evidencies/traces/${NOW}/${TRACE_NAME}.zip
    # ...            recordVideo={'dir':'${OUTPUT_DIR}/evidencies/videos/${NOW}'}
    
Criar usuário via API
    ${EMAIL}  FakerLibrary.Email
    Set Suite Variable    ${EMAIL}
    ${resposta}  Http    url=https://serverest.dev/usuarios
    ...                  method=POST
    ...                  body={"nome": "Elton Rocha","email": "${EMAIL}","password": "123456","administrador": "true"}   

    Should Be Equal As Integers    ${resposta["status"]}    201

Logar com o usuário cadastrado via API
    ${resposta}  Http    url=https://serverest.dev/login
    ...                  method=POST
    ...                  body={"email": "${EMAIL}","password": "123456"}
    Should Be Equal As Integers    ${resposta["status"]}    200
    LocalStorage Set Item    serverest/userEmail    ${EMAIL}
    LocalStorage Set Item    serverest/userToken    ${resposta["body"]["authorization"]}
    LocalStorage Set Item    serverest/userNome     Elton Rocha

    Go To    url=https://front.serverest.dev/admin/home

    Take Screenshot

Cadastrar Usuário e Logar
    New Browser
    New Page      url=${SITE_SERVE_REST}
    Criar usuário via API
    Logar com o usuário cadastrado via API
    ${STORAGE_FILE}  Save Storage State
    Set Suite Variable  ${STORAGE_FILE}

Abrir o Site Serve Rest Front Logado
    New Browser    browser=${BROWSER}
    ...            headless=${HEADLESS}
    New Context    viewport={'width': 1200, 'height': 800}
    ...            storageState=${STORAGE_FILE}
    New Page       url=https://front.serverest.dev/admin/home
    Get Text       h1  ==  Bem Elton Rocha
    Take Screenshot