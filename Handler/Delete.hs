module Handler.Delete where

import Import
import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3,
                              withSmallInput)

getDeleteR :: ArticleId -> Handler Html
getDeleteR articleId = do
      article <- runDB $ do
        delete articleId
      defaultLayout $ do 
        aDomId <- newIdent
        setTitle "Delete page"
        $(widgetFile "delete")
