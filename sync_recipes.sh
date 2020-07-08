#!/bin/bash

for i in {1..9999}
do
    echo "fetch picopak ${i}"
    recipe=$(curl --silent --location --request GET "https://www.picobrew.com/Vendors/input.cshtml?type=ZPicoRecipe&token=<zseries-guid>&id=${i}" \
        --header 'Authorization: Bearer <zseries-bearer-token>')
    
    #recipeId=$(${recipe} | jq '.PicoRecipeID')

    echo ${recipe} > recipes/picopaks/${i}.json

    sleep 5
done
