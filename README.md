# mah-oum

### Prérequis

* terraform
* npm


### Déploiement

0. Créez un account chat et associez-lui la policy `mah_oum_chat` en vous inpisrant du fichier `policy.json`
> N'oubliez pas de remplacer <aws-account-id> par le votre

1. Créez une API GraphQL s'inspirant de l' Event App ( exemple fourni dans la console AppSync )
  ```
    terraform plan && terraform apply
  ``` 

2. Deployez cette application et faites la pointer sur l' API en suivant la documentation: 
https://github.com/amazon-archives/aws-mobile-appsync-events-starter-react
> Pour installer les dépendances, faites plutôt `npm install --legacy-peer-deps`
  

