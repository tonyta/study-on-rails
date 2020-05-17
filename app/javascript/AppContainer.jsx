import React, { Component } from "react"
import SigninForm from "SigninForm"
export default class AppContainer extends Component {
  state = {
    load: false,
    user: null,
  }

  componentDidMount () {
    this.checkSession()
  }

  checkSession = () => {
    fetch("/session", {
      method: "GET",
    }).then(response => {
      return response.json()
    }).then(response => {
      this.setState({
        load: true,
        user: response.current_user,
      })
    })
  }

  signout = (event) => {
    event.preventDefault()

    fetch("/session", {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-TOKEN": document.csrfToken(),
      },
    }).then(response => {
      this.checkSession()
    })
  }

  render () {
    const load = this.state.load
    const user = this.state.user

    if (!load) { return (<div></div>) }
    if (!user) { return (<SigninForm checkSession={this.checkSession}/>) }

    return (
      <div>
        <h2>Welcome, {user}!</h2>
        <button onClick={this.signout}>sign out</button>
      </div>
    )
  }
}
