*** Settings ***
Library    SeleniumLibrary
Library    XML
Library    Collections
Library    String
Library    OperatingSystem
Resource    variables.robot

*** Test Cases ***

#passing test cases

Check if the URL is valid 
    Open Browser    ${URL}    ${Broswer}
    Title Should Be    Sign up and Login Page
    [Teardown]    Close Browser

Administrator Login with valid Credentials

    Login    ${ValidAdminUserName}    ${ValidAdminPwd}
    Wait Until Page Contains    User Details Page    timeout=2    #to wait for the page title to load
    [Teardown]    Close Browser


Sign up
    Open Browser    ${URL}    ${Broswer}
    Wait Until Element Is Visible    id=loginForm    timeout=2
    Click Button    id=nav-signup-tab
    Wait Until Element Is Visible    id=signupForm    timeout=2
    Input Text    id=signup_username    ${signup_username}
    Input Password    id=signup_password    ${signup_password}
    Click Button    id=signup_button
    #Alert Should Be Present    Account request sent
    ${message}=    Handle Alert   
    Should Contain    ${message}    Account request sent
    [Teardown]    Close Browser


Normal user login with valid Credentials
    Login    ${ValidNormalUser}    ${ValidNormalPwd}
    Title Should Be    User Main Page
    [Teardown]    Close Browser


Delete User Account 
    Login    ${ValidAdminUserName}    ${ValidAdminPwd}
    Wait Until Element Is Visible    class=table    timeout=2
    #Get the last delete button
    ${delete_button}=    Get WebElements    xpath://button[contains(text(), 'delete')]
    ${delete_button}=    Set Variable    ${delete_button[-1]}
    Mouse Over    ${delete_button}
    #Get the ID before deleting
    ${prev_value}=    Get Table Cell    class=table    -1    1
    Click Element    ${delete_button}
    ${message}=    Handle Alert
    Should Contain    ${message}    Are you sure you want to delete
    #Get the ID after deleting and check if deleted
    ${cur_value}=    Get Table Cell    class=table    -1    1
    Should Not Be Equal    ${prev_value}    ${cur_value}
    [Teardown]    Close Browser


Modify User Account
    Login    ${ValidAdminUserName}    ${ValidAdminPwd}
    Wait Until Element Is Visible    class=table    timeout=2
    #find the last modify button
    ${modify_button}=    Get WebElements    xpath://button[contains(text(), 'modify')]
    ${modify_button}=    Set Variable    ${modify_button[-1]}
    Mouse Over    ${modify_button}
    #get the value of the ID before modifying and click on modify
    ${prev_value}=    Get Table Cell    class=table    -1    1
    Click Element    ${modify_button}
    Page Should Contain    Update    #change to title should be
    #input text for modification 
    Wait Until Element Is Visible    id=modifyForm    timeout=2
    Input Text    id=modify_username    ${modifiedUser}
    Click Button    id=update_user_button
    #get the current ID and the username
    Wait Until Element Is Visible    class=table    timeout=2
    ${cur_value}=    Get Table Cell    class=table    -1    1
    ${cur_name}=    Get Table Cell    class=table    -1    2
    Log    ${cur_value}
    Log    ${cur_name}
    #check that the ID is the same before and after and the name is changed to given input
    Should Be Equal As Strings    ${prev_value}    ${cur_value}
    Should Be Equal As Strings    ${modifiedUser}    ${cur_name}
    #give alert and check 
    [Teardown]    Close Browser


Approve User Accounts
    Login    ${ValidAdminUserName}    ${ValidAdminPwd}
    Wait Until Element Is Visible    class=table    timeout=2
    #find last appprove button
    ${approve_button}=    Get WebElements    xpath=//button[contains(text(), 'approve')]
    ${approve_button}=    Set Variable    ${approve_button[-1]}
    Mouse Over    ${approve_button}
    Click Button    ${approve_button}
    [Teardown]    Close Browser


#failing test cases
Login with invalid Credentials
    Login    ${invalid_username}    ${invalid_password}
    Should Contain    id=error-message    Invalid Credentials
    [Teardown]    Close Browser



Cancel Deletion of User Account
    Login    ${ValidAdminUserName}    ${ValidAdminPwd}
    Wait Until Element Is Visible    class=table    timeout=2
    #Get the last delete button
    ${delete_button}=    Get WebElements    xpath://button[contains(text(), 'delete')]
    ${delete_button}=    Set Variable    ${delete_button[-1]}
    #Get the ID before clicking on delete
    ${prev_value}=    Get Table Cell    class=table    -1    1
    Log    ${prev_value}
    Mouse Over    ${delete_button}
    Click Element    ${delete_button}
    Handle Alert    DISMISS
    #Get the ID after clicking on delete, should be the same as the Delete operation is cancelled
    ${cur_value}=    Get Table Cell    class=table    -1    1
    Should Be Equal As Strings    ${prev_value}    ${cur_value}
    [Teardown]    Close Browser


*** Keywords ***
Login
    [Arguments]    ${username}    ${password}
    Open Browser    ${URL}    ${Broswer}
    #Maximize Browser Window
    Wait Until Element Is Visible    id=loginForm    timeout=2
    Input Text    ${username_textbox}    ${username}
    Input Password    ${pwd_textbox}    ${password}
    Click Button    ${login_button}   
    
