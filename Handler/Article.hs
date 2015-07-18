module Handler.Article where

import Import
import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3,
                              withSmallInput)

getArticleR :: ArticleId -> Handler Html
getArticleR articleId = do
      article <- runDB $ do
        article <- get404 articleId
        return article
      defaultLayout $ do 
        aDomId <- newIdent
        setTitle "Article page"
        $(widgetFile "article")
