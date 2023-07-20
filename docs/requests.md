## Requests

### Delete Item

```js
await fetch("https://stacker.news/api/graphql", {
  credentials: "include",
  headers: {
    "User-Agent":
      "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0",
    Accept: "*/*",
    "Accept-Language": "en-US,en;q=0.5",
    "Content-Type": "application/json",
    "Sec-Fetch-Dest": "empty",
    "Sec-Fetch-Mode": "cors",
    "Sec-Fetch-Site": "same-origin",
    "Sec-GPC": "1",
  },
  referrer: "https://stacker.news/usernamehere",
  body: '{"operationName":"deleteItem","variables":{"id":"1111111"},"query":"mutation deleteItem($id: ID!) {\\n  deleteItem(id: $id) {\\n    text\\n    title\\n    url\\n    pollCost\\n    deletedAt\\n    __typename\\n  }\\n}\\n"}',
  method: "POST",
  mode: "cors",
});
```

### Create Comment

```js
await fetch("https://stacker.news/api/graphql", {
  credentials: "include",
  headers: {
    "User-Agent":
      "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0",
    Accept: "*/*",
    "Accept-Language": "en-US,en;q=0.5",
    "Content-Type": "application/json",
    "Sec-Fetch-Dest": "empty",
    "Sec-Fetch-Mode": "cors",
    "Sec-Fetch-Site": "same-origin",
    "Sec-GPC": "1",
  },
  referrer: "https://stacker.news/usernamehere",
  body: '{"operationName":"createComment","variables":{"text":"test\\nmultiline\\ntext\\n123","parentId":"1111111"},"query":"fragment CommentFields on Item {\\n  id\\n  parentId\\n  createdAt\\n  deletedAt\\n  text\\n  user {\\n    name\\n    streak\\n    hideCowboyHat\\n    id\\n    __typename\\n  }\\n  sats\\n  upvotes\\n  wvotes\\n  boost\\n  meSats\\n  meDontLike\\n  meBookmark\\n  meSubscription\\n  outlawed\\n  freebie\\n  path\\n  commentSats\\n  mine\\n  otsHash\\n  ncomments\\n  __typename\\n}\\n\\nfragment CommentsRecursive on Item {\\n  ...CommentFields\\n  comments {\\n    ...CommentFields\\n    comments {\\n      ...CommentFields\\n      comments {\\n        ...CommentFields\\n        comments {\\n          ...CommentFields\\n          comments {\\n            ...CommentFields\\n            comments {\\n              ...CommentFields\\n              comments {\\n                ...CommentFields\\n                comments {\\n                  ...CommentFields\\n                  comments {\\n                    ...CommentFields\\n                    comments {\\n                      ...CommentFields\\n                      comments {\\n                        ...CommentFields\\n                        comments {\\n                          ...CommentFields\\n                          comments {\\n                            ...CommentFields\\n                            comments {\\n                              ...CommentFields\\n                              comments {\\n                                ...CommentFields\\n                                comments {\\n                                  ...CommentFields\\n                                  comments {\\n                                    ...CommentFields\\n                                    comments {\\n                                      ...CommentFields\\n                                      comments {\\n                                        ...CommentFields\\n                                        comments {\\n                                          ...CommentFields\\n                                          comments {\\n                                            ...CommentFields\\n                                            comments {\\n                                              ...CommentFields\\n                                              comments {\\n                                                ...CommentFields\\n                                                comments {\\n                                                  ...CommentFields\\n                                                  comments {\\n                                                    ...CommentFields\\n                                                    __typename\\n                                                  }\\n                                                  __typename\\n                                                }\\n                                                __typename\\n                                              }\\n                                              __typename\\n                                            }\\n                                            __typename\\n                                          }\\n                                          __typename\\n                                        }\\n                                        __typename\\n                                      }\\n                                      __typename\\n                                    }\\n                                    __typename\\n                                  }\\n                                  __typename\\n                                }\\n                                __typename\\n                              }\\n                              __typename\\n                            }\\n                            __typename\\n                          }\\n                          __typename\\n                        }\\n                        __typename\\n                      }\\n                      __typename\\n                    }\\n                    __typename\\n                  }\\n                  __typename\\n                }\\n                __typename\\n              }\\n              __typename\\n            }\\n            __typename\\n          }\\n          __typename\\n        }\\n        __typename\\n      }\\n      __typename\\n    }\\n    __typename\\n  }\\n  __typename\\n}\\n\\nmutation createComment($text: String!, $parentId: ID!) {\\n  createComment(text: $text, parentId: $parentId) {\\n    ...CommentFields\\n    comments {\\n      ...CommentsRecursive\\n      __typename\\n    }\\n    __typename\\n  }\\n}\\n"}',
  method: "POST",
  mode: "cors",
});
```
