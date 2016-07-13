## Golang Github library https://github.com/google/go-github

##### Sync Calls:
This library lets you support asynchronous calls through channels.

##### Callback Support:
* According to the requirement of Planner the best way is to have Asynchronous requests.
* The Github Go library have a quite good support to do it through channels and function callback as well.

##### Query:
The query passed is passed as “is:open is:issue user:arquillian author:aslakknutsen”

##### Individual Lookup:
* For Public repositories we don’t need any ID or key
* To access and query the Private repositories we will need the personal access token of the user and authenticate the application as explained further in the Auth section.

##### Collect Sample Data:
http://www.tegdesign.com/querying-github-api-golang-find-magento-repositories/

##### Auth models:
To use GitHub API from Go we can use github.com/google/go-github package. GitHub, like many other sites, uses OAuth 2.0 protocol for authentication. There are few packages for Go that implement OAuth. read this sample.
Short intro to OAuth for GitHub
* To access private info about the user via the API in your web app you need to authenticate your app against GitHub website.
* First, you need to register your application with GitHub (under Developer applications). You provide description of the app, including a callback url (we’ll get back to that). GitHub creates client id and client secret that you’ll need to provide to OAuth libraries (and keep them secret).
* The flow of OAuth is:
the user is on your website and clicks “login with GitHub” link
you redirect the user to GitHub’s authorization page. In that url you specify desired access level and a random secret
the user authorizes your app by clicking on a link
GitHub redirects to a callback url on your website (which you provided when registering the app with GitHub)
in the url handler, extract “secret” and “code” args
you have to check that the secret is the same as the one you sent to GitHub (security measure that prevents forgery)
* you call another GitHub url to exchange code for access token
Access token is what you use to authenticate your API calls.

##### Auth work around

```golang
func main() {
  ts := oauth2.StaticTokenSource(
    &oauth2.Token{AccessToken: "... your access token ..."},
  )
  tc := oauth2.NewClient(oauth2.NoContext, ts)

  client := github.NewClient(tc)

  // list all repositories for the authenticated user
  repos, _, err := client.Repositories.List("", nil)
}
```

##### Auth levels

Auth | Permissions
------- | ---------
Public repo   | can query without username or API key
Private repo  | Need to authenticate App with personal access token

##### Notes on callback url
callback url is defined when the ap is registered. This is a problem for testing, because your app might use different hosts for development or production. One option is to create different apps for testing and production, with different callback urls. OAuth protocol allows providing callback url as an argument when calling authorization page (and oauth2 library allows setting it as oauth2.Config.RedirectURL) but GitHub has restrictions and doesn’t allow changing host.
Using personal access token
If you want to access someone else’s GitHub info, you need to authorize your app with GitHub as described above. If you want to access your own account, you can generate a personal access token.
For querying a public repository, no auth level is required


##### Required auth levels for different interactions
* Query: for public repo no auth required, for private repos required
* Lookup: Same as querying but for repository app needs to authenticate the user
* Callback: Same as Query and lookup.


## Trello

##### Sync calls only
Go Library for trello supports Asynchronous calls through channels.

##### Callback support
According to the requirements of application the best way is to have Asynchronous requests. And using go channels will solve this issue or function callback is also supported by the library.

##### Query
Query is given as the boardId and the list name we want to    search.
>listName: ‘Epic Backlog’,
>boardId: ‘nlLwlKoz’

##### Individual lookup
Lookup through API key can get all its related credentials as the query we have for a particular user for a boardId and a listName

##### Collect sample data
 Doc for usage of Library https://godoc.org/github.com/VojtechVitek/go-trello

##### Auth models:
Using the Trello object, we need to authenticate the user.
* This is done with the Trello.authenticate method. This method will automatically trigger the OAuth flow and return back a token. This token will be specific to your Application ID and the user who is executing the flow.
* It's important to understand that the Authentication Token gives application the ability to make calls on behalf of your user, from their context. This token grants access to the authenticated user's boards, lists, Cards, and other settings, depending on the permissions you requested in the authenticate method.

##### Auth Work around
```golang
package main

import (
    "fmt"
    "log"
    "github.com/VojtechVitek/go-trello"
)

func main() {
    // New Trello Client
    appKey := "application-key"
    token := "token"
    trello, err := trello.NewAuthClient(appKey, &token)
    if err != nil {
        log.Fatal(err)
    }

    // User @trello
    user, err := trello.Member("trello")
    if err != nil {
        log.Fatal(err)
    }
    fmt.Println(user.FullName)

    // @trello Boards
    boards, err := user.Boards()
    if err != nil {
        log.Fatal(err)
    }
```

##### Auth levels

Auth | Permissions
------- | ---------
Public board   | Need Username
Private board  | Need API key and token to authenticate

##### Required auth levels for different interactions
* Query : For querying public boards only username is needed. Other than that API key is needed
* Lookup : Same as Querying, API Key and token are needed for the private boards.
* Callback: Username, API key and token are needed.


## Trello Golang libraries

|        | Completeness                                                  | Style           | Community                                                                                                                               |                                                                               Feature Support | Auth  Support                                                                                                                                                                                           | Version    |
|:--------|:---------------------------------------------------------------|:-----------------|:-----------------------------------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:------------|
| go-Trello <ul><li>https://github.com/VojtechVitek/go-trello</li></ul>| Complete/Accomplish all functionalities which will be needed  | Object oriented | <ul><li>last commit - on February 26</li><li>last pull request- on february 28</li><li> No. of users: 23 and 31 stars</li></ul>                                           | All the important and needed functionalities are supported by this library                    | User Name is needed as the basic auth support other than that to access Private cards API Key is needed and as a Application perspective we need to authenticate the app with user’s API key and token. | 0.1        |
| go-Trello <ul><li>https://github.com/octokit/go-octokit</li><li>https://golanglibs.com/top?q=trello</li></ul>| Complete | Object oriented | <ul><li>last commit - on February 26</li><li>last pull request- on february 28</li><li> No. of users: 23 and 31 stars</li></ul>                                           | All the important and needed functionalities are supported by this library                    | User Name is needed as the basic auth support other than that to access Private cards API Key is needed and as a Application perspective we need to authenticate the app with user’s API key and token. | 0.1        |

## Trello Python libraries

|        | Completeness                                                  | Style           | Community                                                                                                                               |                                                                               Feature Support | Auth  Support                                                                                                                                                                                           | Version    |
|:--------|:---------------------------------------------------------------|:-----------------|:-----------------------------------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:------------|
| py-Trello <ul><li>Github Repo: https://github.com/sarumont/py-trello</li></ul><ul><li>https://pythonhosted.org/trello/trello.html</li></ul><ul><li>Examples: https://pythonhosted.org/trello/examples.html</li></ul>| Complete | Object oriented | <ul><li>last commit - on June 7 2016</li><li>last pull request- July 7 2016</li><li> Pull requests: 94</li><li>No. of contributors: 55</li></ul>                                           | All the important and needed functionalities are supported by this library                    | OAuth is supported and API Key and token is necessary. | 14        |
| py-Trello <ul><li>https://github.com/plish/Trolly</li></ul>|  Incomplete | Object oriented | <ul><li>last commit - on March 1 2016</li><li>last pull request- February 25 2016</li><li> Pull requests: 25</li><li>No. of contributors: 8</li></ul>                                           | Trello functionalities are there but no auth support till now.             | Library has no auth support. | No Version |

## Github Golang libraries

|        | Completeness                                                  | Style           | Community                                                                                                                               |                                                                               Feature Support | Auth  Support                                                                                                                                                                                           | Version    |
|:--------|:---------------------------------------------------------------|:-----------------|:-----------------------------------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:------------|
| Go-Github <ul><li>https://github.com/google/go-github</li></ul> | Complete/Accomplish all functionalities which will be needed  | Object oriented | <ul><li>last commit - on 8 July 2016</li><li>Last Pull Request - on 10 July 2016</li><li> Pull requests: 247</li><li>No. of contributors: 95</li></ul>| All the important features are supported by the library and many are being added continuously | OAuth2 is supported for Github library and the app needs to get registered with github.A description plus a callback url is needed                                                                      | No version |
| go-octokit for golang github <ul><li>https://github.com/octokit/go-octokit</li></ul> | Some features are not yet added | Object oriented | <ul><li>last commit - on 12 March 2016</li><li>Last Pull Request - on 31 May 2016</li><li> Pull requests: 121</li><li>No. of contributors: 22</li></ul>| Go toolkit for the GitHub API, go-octokit is designed to be a hypermedia API client that wraps the GitHub API. | Auth is not supported for private repositories                                                                      | 4 |

## Github Python libraries

|        | Completeness                                                  | Style           | Community                                                                                                                               |                                                                               Feature Support | Auth  Support                                                                                                                                                                                           | Version    |
|:--------|:---------------------------------------------------------------|:-----------------|:-----------------------------------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:------------|
| PyGithub <ul><li>https://github.com/PyGithub/PyGithub</li></ul>| Complete | Object oriented | <ul><li>last commit - on 8 July 2016</li><li>Last Pull Request - on 8 July 2016</li><li> Pull requests: 116</li><li>No. of contributors: 60</li></ul>| All the important features are supported by the library and many are being added continuously | OAuth2 is supported for Github library and the app needs to get registered with github.A description plus a callback url is needed                                                                      | 49 |
| PyGithub <ul><li>https://github.com/copitux/python-github3</li></ul>| Complete | Object oriented | <ul><li>last commit - on 28 November 2014</li><li>Last Pull Request - on 9 December 2015</li><li> Pull requests: 38</li><li>No. of contributors: 10</li></ul>| All the features of github is supported by the library| OAuth is used to authenticate a user                                                                  | 5 |
