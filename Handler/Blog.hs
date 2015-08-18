module Handler.Blog where

import Import
{- import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3, -}
                              {- withSmallInput) -}

-- This is a handler function for the GET request method on the HomeR
-- resource pattern. All of your resource patterns are defined in
-- config/routes
--
-- The majority of the code you will write in Yesod lives in these handler
-- functions. You can spread them across multiple files if you are so
-- inclined, or create a single monolithic file.

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
  <$> areq textField "title" (Just (title d))
  <*> areq htmlField "" (Just (body d))
  <*> lift  (liftIO getCurrentTime)

articleForm :: DefaultArticle -> Form Article
articleForm d = renderTable $ articleAForm d


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
