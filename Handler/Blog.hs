module Handler.Blog where

import Import
import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3, bfs)

data DefaultArticle = DefaultArticle{
                      title :: Text
                    , body :: Html
                    } 

defaultValue :: DefaultArticle
defaultValue = DefaultArticle 
                 "" 
                 ""


articleAForm :: DefaultArticle -> AForm Handler Article
articleAForm d = Article
  <$> areq textField (bfs ("Title" :: Text)) (Just (title d))
  <*> areq htmlField (bfs ("Body" :: Text) ) (Just (body d))
  <*> lift  (liftIO getCurrentTime)

articleForm :: DefaultArticle -> Form Article
articleForm d = renderBootstrap3 BootstrapBasicForm $ articleAForm d


getBlogR :: Handler Html
getBlogR = do
    articles <- runDB $ selectList [] [Desc ArticleDate]
    (formWidget, formEnctype) <- generateFormPost $ articleForm defaultValue
    defaultLayout $ do
        aDomId <- newIdent
        setTitle "Blog Page"
        $(widgetFile "blog")
       
postBlogR :: Handler Html
postBlogR = do
    ((result, _), formEnctype) <- runFormPost $ articleForm defaultValue
    case result of 
      FormSuccess article -> do
        articleId <- runDB $ insert article
        redirect $ ArticleR articleId
      _                   -> defaultLayout $ do
                               setTitle "PostArtcile"
                               [whamlet|
                               <form method="post" enctype=#{formEnctype}>
                               |]
