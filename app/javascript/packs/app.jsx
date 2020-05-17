import React from "react"
import ReactDOM from "react-dom"

import AppContainer from "../AppContainer"

document.csrfToken = () => {
  const html_tag = document.querySelector("[name=csrf-token]")
  if (html_tag) { return html_tag.content }
}

document.addEventListener("DOMContentLoaded", () => {
  ReactDOM.render(
    <AppContainer />,
    document.body.appendChild(document.createElement("div")),
  )
})
