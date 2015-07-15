module Handler.Pera where

import Import
import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3,
                              withSmallInput)

-- This is a handler function for the GET request method on the HomeR
-- resource pattern. All of your resource patterns are defined in
-- config/routes
--
-- The majority of the code you will write in Yesod lives in these handler
-- functions. You can spread them across multiple files if you are so
-- inclined, or create a single monolithic file.

{- articleForm ::  -}
articleAForm :: AForm Handler Article
articleAForm = Article
  <$> areq textField "title" Nothing
  <*> areq textField "body" Nothing
  <*> areq dayField "Year"  Nothing

articleForm :: Html -> MForm Handler (FormResult Article, Widget)
articleForm = renderTable articleAForm



getPeraR :: Handler Html
getPeraR = do
    (formWidget, formEnctype) <- generateFormPost articleForm
    let handlerName = "getPeraR" :: Text
    defaultLayout $ do
        aDomId <- newIdent
        setTitle "Welcome To Get!"
        $(widgetFile "pera")
       
postPeraR :: Handler Html
postPeraR = do
    ((result, formWidget), formEnctype) <- runFormPost articleForm
    let handlerName = "postHomeR" :: Text
        submission = case result of 
                       FormSuccess res -> Just res
                       _               -> Nothing 
    let article = submission
    defaultLayout $ do
        aDomId <- newIdent
        setTitle "PostArtcile"
        $(widgetFile "pera")
