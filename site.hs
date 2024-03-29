--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}

import Hakyll

--------------------------------------------------------------------------------

main :: IO ()
main = hakyllWith config $ do
  match "templates/*" $ compile templateCompiler

  match "css/*" $ do
    route idRoute
    compile compressCssCompiler

  match "images/*" $ do
    route idRoute
    compile copyFileCompiler

  match "index.html" $ do
    route idRoute
    compile $ do
      posts <- recentFirst =<< loadAll "posts/**"
      let indexCtx =
            listField "posts" postCtx (pure posts)
              <> constField "title" "Home"
              <> defaultContext

      getResourceBody
        >>= applyAsTemplate indexCtx
        >>= loadAndApplyTemplate "templates/default.html" indexCtx
        >>= relativizeUrls

  match (fromList ["about.md", "contact.md"]) $ do
    route $ setExtension "html"
    compile $
      pandocCompiler
        >>= loadAndApplyTemplate "templates/default.html" defaultContext
        >>= relativizeUrls

  match "posts/*" $ do
    route $ setExtension "html"
    compile $
      pandocCompiler
        >>= loadAndApplyTemplate "templates/post.html" postCtx
        >>= loadAndApplyTemplate "templates/default.html" postCtx
        >>= relativizeUrls

  create ["archive.html"] $ do
    route idRoute
    compile $ do
      posts <- recentFirst =<< loadAll "posts/*"
      let archiveCtx =
            listField "posts" postCtx (pure posts)
              <> constField "title" "Archives"
              <> defaultContext

      makeItem ""
        >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
        >>= loadAndApplyTemplate "templates/default.html" archiveCtx
        >>= relativizeUrls

--------------------------------------------------------------------------------
-- Config

config :: Configuration
config =
  defaultConfiguration
    { destinationDirectory = "docs"
    }

--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
  dateField "date" "%B %e, %Y"
    <> defaultContext
