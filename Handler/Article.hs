module Handler.Article where

import Import

getArticleR :: ArticleId -> Handler Html
getArticleR articleId = do
      article <- runDB $ do
        article <- get404 articleId
        return article
      defaultLayout $ do 
        aDomId <- newIdent
        setTitle "Article page"
        $(widgetFile "article")
