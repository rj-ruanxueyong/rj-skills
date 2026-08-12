*** Settings ***
Suite Setup       ${SUITE_SETUP}
Suite Teardown    ${SUITE_TEARDOWN}
Resource          ${RESOURCE_1}
Resource          ${RESOURCE_2}
Resource          ${RESOURCE_3}
Resource          ${RESOURCE_4}
Library           OperatingSystem
Library           DateTime

*** Variables ***
${RESULT_FILE}    ${CURDIR}${/}result.txt

*** Test Cases ***
${CASE_NAME_1}
    [Documentation]    用例编号：${CASE_ID_1}
    ...
    ...    用例名称：${CASE_NAME_1}
    ...
    ...    编写人员：
    ...
    ...    编写日期：
    ...
    ...    测试描述：
    ...
    ...    ${CASE_DESCRIPTION}
    [Tags]    ${TAG_1}    ${TAG_2}
    [Setup]    ${CASE_SETUP}
    Write Result Log    测试步骤：${STEP_1}
    ${STEP_1_KEYWORD}    ${STEP_1_ARGS}
    Write Result Log    预期描述：${EXPECT_1}
    [Teardown]    ${CASE_TEARDOWN}

${CASE_NAME_2}
    [Documentation]    用例编号：${CASE_ID_2}
    ...
    ...    用例名称：${CASE_NAME_2}
    ...
    ...    编写人员：
    ...
    ...    编写日期：
    ...
    ...    测试描述：
    ...
    ...    ${CASE_DESCRIPTION}
    [Tags]    ${TAG_1}    ${TAG_2}
    [Setup]    ${CASE_SETUP}
    Write Result Log    测试步骤：${STEP_1}
    ${STEP_1_KEYWORD}    ${STEP_1_ARGS}
    Write Result Log    预期描述：${EXPECT_1}
    [Teardown]    ${CASE_TEARDOWN}

*** Keywords ***
Initialize Result File
    ${now}    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Create File    ${RESULT_FILE}    [${now}] 用例启动: ${CASE_ID}${\n}

Write Result Log
    [Arguments]    ${message}
    ${now}    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${line}    Catenate    SEPARATOR=    [${now}]    ${SPACE}    ${message}    ${\n}
    Append To File    ${RESULT_FILE}    ${line}
    Log    ${message}