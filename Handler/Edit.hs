module Handler.Edit where

import Import
import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3, bfs) 

{- data ArticleWithId = ArticleWithId -}
                     {- { [> getId :: ArticleId <] -}
                       {- getTitle :: Text -}
                     {- , getBody :: Html -}
                     {- } -}

articleAForm :: Article -> AForm Handler Article
articleAForm article = Article
  <$> areq textField (bfs ("Title" :: Text)) (Just (articleTitle article))
  <*> areq htmlField (bfs ("Body" :: Text))  (Just (articleBody article))
  <*> lift (liftIO getCurrentTime)

articleForm :: Article -> Form Article
articleForm article = renderBootstrap3 BootstrapBasicForm $ articleAForm article

getEditR :: ArticleId -> Handler Html
getEditR articleId = do
    article <- runDB $ get404 articleId
    (formWidget, _) <- generateFormPost $ articleForm article
    defaultLayout $ do
        aDomId <- newIdent
        setTitle "Edit Page"
        $(widgetFile "edit")
      
postEditR :: ArticleId -> Handler Html
postEditR articleId = do
    article <- runDB $ get404 articleId
    ((result, _), formEnctype) <- runFormPost $ articleForm article
    case result of 
      FormSuccess articleWithId -> do
        runDB $ update (articleId) [ArticleTitle =. (articleTitle articleWithId), ArticleBody =. (articleBody articleWithId)]
        redirect $ ArticleR articleId
      _                   -> defaultLayout $ do
                               setTitle "PostArtcile"
                               [whamlet|
                               <form method=        "        post" enctype=#{formEnctype}>
                               |]
