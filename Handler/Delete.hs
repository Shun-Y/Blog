module Handler.Delete where

import Import

getDeleteR :: ArticleId -> Handler Html
getDeleteR articleId = do
      article <- runDB $ do
        delete articleId
      defaultLayout $ do 
        aDomId <- newIdent
        setTitle "Delete page"
        $(widgetFile "delete")
