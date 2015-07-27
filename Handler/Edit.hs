module Handler.Edit where

import Import
import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3, withSmallInput, bfs) 

data ArticleWithId = ArticleWithId{
                       getId :: ArticleId
                     ,  getTitle :: Text
                     , getBody :: Html
                     }

articleAForm :: ArticleId -> Article -> AForm Handler ArticleWithId
articleAForm articleId article = ArticleWithId
  <$> pure articleId
  <*> areq textField (bfs ("Title" :: Text)) (Just (articleTitle article))
  <*> areq htmlField (bfs ("Body" :: Text))  (Just (articleBody article))

articleForm :: ArticleId -> Article -> Form ArticleWithId
articleForm articleId article = renderBootstrap3 BootstrapBasicForm $ articleAForm articleId article

getEditR :: ArticleId -> Handler Html
getEditR articleId = do
    article <- runDB $ get404 articleId
    (formWidget, _) <- generateFormPost $ articleForm articleId article
    defaultLayout $ do
        aDomId <- newIdent
        setTitle "Edit Page"
        $(widgetFile "edit")
      
postEditR :: ArticleId -> Handler Html
postEditR articleId = do
    article <- runDB $ get404 articleId
    ((result, _), formEnctype) <- runFormPost $ articleForm articleId article
    case result of 
      FormSuccess articleWithId -> do
        runDB $ update (getId articleWithId) [ArticleTitle =. (getTitle articleWithId), ArticleBody =. (getBody articleWithId)]
        redirect $ ArticleR articleId
      _                   -> defaultLayout $ do
                               setTitle "PostArtcile"
                               [whamlet|
                               <form method="post" enctype=#{formEnctype}>
                               |]
