module Handler.Edit where

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

data ArticleWithId = ArticleWithId{
                       getId :: ArticleId
                     ,  getTitle :: Text
                     , getBody :: Html
                     }

articleAForm :: ArticleId -> Article -> AForm Handler ArticleWithId
articleAForm articleId article = ArticleWithId
  <$> pure articleId
  <*> areq textField "Title" (Just (articleTitle article))
  <*> areq htmlField "Body"  (Just (articleBody article))

articleForm :: ArticleId -> Article -> Form ArticleWithId
articleForm id article = renderTable $ articleAForm id article

getEditR :: ArticleId -> Handler Html
getEditR articleId = do
    article <- runDB $ get404 articleId
    (formWidget, formEnctype) <- generateFormPost $ articleForm articleId article
    defaultLayout $ do
        aDomId <- newIdent
        setTitle "Edit Page"
        $(widgetFile "edit")
      
postEditR :: ArticleId -> Handler Html
postEditR articleId = do
    article <- runDB $ get404 articleId
    ((result, formWidget), formEnctype) <- runFormPost $ articleForm articleId article
    case result of 
      FormSuccess articleWithId -> do
        runDB $ update (getId articleWithId) [ArticleTitle =. (getTitle articleWithId), ArticleBody =. (getBody articleWithId)]
        redirect $ ArticleR articleId
      _                   -> defaultLayout $ do
                               setTitle "PostArtcile"
                               [whamlet|
                               <form method="post" enctype=#{formEnctype}>
                               |]
