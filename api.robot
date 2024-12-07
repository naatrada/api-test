*** Settings ***
Library               RequestsLibrary
Library               BuiltIn


*** Variables ***
${BASE_URL}       https://fakestoreapi.com
${product_id}    1
${invalid_product_id}    100

***Test Cases***
Test GET Products
    [Documentation]    Test to get all products.
    [Tags]    API    GET
    ${response}=    GET    ${BASE_URL}/products
    Log to console    ${response}
    Should Be Equal As Numbers    ${response.status_code}    200
    ${json}=    To Json    ${response.text}
    Log to console    ${json}

Test POST Product
    [Documentation]    Test to create a new product.
    [Tags]    API    POST
    ${valid_product}=    Create Dictionary    title=Test Product    price=11.11    description=test    category=men's clothing
    ${response}=    POST    ${BASE_URL}/products    json=${valid_product}
    Log To Console    ${response.status_code}
    Should Be Equal As Numbers    ${response.status_code}    200
    Log To Console    ${response.text}  # To inspect the error message

# Test POST Invalid Product 
#     [Documentation]    Test to try to post an invalid product.
#     [Tags]    API    POST
#     ${invalid_product}=    Create Dictionary       price=" "    description=''    image=
#     # Log To Console    ${invalid_product}
#     ${response}=    POST    ${BASE_URL}/products    json=${invalid_product}
#     Log To Console    ${response.status_code}
#     Log To Console    ${response.text}
#     Should Be Equal As Numbers    ${response.status_code}    400
#     Should Contain    ${response.text}    "error"  # Assuming 'error' is part of the response body in case of bad request

Test PUT Product
    [Documentation]    Test to update an existing product.
    [Tags]    API    PUT    
    ${updated_product}=    Create Dictionary    title=Updated Product    price=14.99
    ${response}=    PUT    ${BASE_URL}/products/${product_id}    json=${updated_product}
    Should Be Equal As Numbers    ${response.status_code}    200
    ${json}=    To Json    ${response.text}
    Should Contain    ${json['title']}    Updated Product

# Test PUT invalid Product
#     [Documentation]    Test to update an existing product.
#     [Tags]    API    PUT    
#     ${updated_product}=    Create Dictionary    title=Updated Product    price=14.99
#     ${response}=    PUT    ${BASE_URL}/products/${invalid_product_id}    json=${updated_product}
#     Should Be Equal As Numbers    ${response.status_code}    400
#     ${json}=    To Json    ${response.text}
#     Should Contain    ${json['title']}    Updated Product

Test DELETE valid Product 
    [Documentation]    Test to delete a product.
    [Tags]    API    DELETE
    ${response}=    DELETE    ${BASE_URL}/products/${product_id}
    Should Be Equal As Numbers    ${response.status_code}    200

# Test DELETE invalid Product 
#     [Documentation]    Test to delete an invalid product.
#     [Tags]    API    DELETE
#     ${response}=    DELETE    ${BASE_URL}/products/${invalid_product_id}
#     Should Be Equal As Numbers    ${response.status_code}    400

Test GET Categories
    [Documentation]    Test to retrieve product categories.
    [Tags]    API    GET
    ${response}=    GET    ${BASE_URL}/products/categories
    Should Be Equal As Numbers    ${response.status_code}    200
    ${json}=    To Json    ${response.text}
    Log To Console    ${response.text}
    ${length}=    Get Length    ${json}  
    Length Should Be    ${json}    ${length}

Test GET Sorted by asc Products
    [Documentation]    Test to get products sorted by asc id.
    [Tags]    API    GET
    ${params}=    Create Dictionary    sort=asc
    ${response}=    GET    ${BASE_URL}/products    params=${params}
    Should Be Equal As Numbers    ${response.status_code}    200
    ${json}=  To Json      ${response.text}
    # Log To Console    ${response.text}
    Should Be Equal    ${json[0]['title']}   Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops
     
Test GET Sorted by desc Products
    [Documentation]    Test to get products sorted by desc id.
    [Tags]    API    GET
    ${params}=    Create Dictionary    sort=desc
    ${response}=    GET    ${BASE_URL}/products    params=${params}
    Should Be Equal As Numbers    ${response.status_code}    200
    ${json}=  To Json      ${response.text}
    # Log To Console    ${response.text}
    Should Be Equal    ${json[0]['title']}   DANVOUY Womens T Shirt Casual Cotton Short 


