#!/bin/bash

z_uid="<z-guid>"
z_auth="<z-bearer-token>"


for i in {1..10239}
do
    echo "fetch picopak ${i}"
    recipe=$(curl --silent --location --request GET "https://www.picobrew.com/Vendors/input.cshtml?type=ZPicoRecipe&token=${z_uid}&id=${i}" \
        --header "Authorization: Bearer ${z_auth}")
    
    #recipeId=$(${recipe} | jq '.PicoRecipeID')

    echo ${recipe} > recipes/picopaks/${i}.json

    #sleep 5
done

echo "fetching zpaks"
zpaks=$(curl --silent --location --request POST "https://www.picobrew.com/Vendors/input.cshtml?ctl=RecipeRefListController&token=${z_uid}" \
        --header "Authorization: Bearer ${z_auth}" \
        --header 'Content-Type: application/json' \
        --data-raw '{
            "Kind": 3,
            "MaxCount": 50,
            "Offset": 0
        }')

# echo "${zpaks}"

for row in $(echo "${zpaks}" | jq -r '.Recipes[] | @base64'); do
    _jq() {
         echo ${row} | base64 --decode | jq -r ${1}
    }

    echo "fetch zpak instructions" $(_jq '.ID') $(_jq '.Name')

    i=$(_jq '.ID')

    recipe=$(curl --silent --location --request GET "https://www.picobrew.com/Vendors/input.cshtml?type=Recipe&token=${z_uid}&id=${i}" \
        --header "Authorization: Bearer ${z_auth}")
    
    #recipeId=$(${recipe} | jq '.PicoRecipeID')

    echo ${recipe} > recipes/zpaks/${i}.json
    # echo $(_jq '.ID')
done

