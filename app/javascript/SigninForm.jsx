import React, { Component } from "react"

export default class SigninForm extends Component {
  state = {
    username: "",
    password: "",
  }

  updateInput = (event) => {
    this.setState({[event.target.name]: event.target.value})
  }

  signin = (event) => {
    event.preventDefault()

    fetch("/session", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-TOKEN": document.csrfToken(),
      },
      body: JSON.stringify(this.state),
    }).then(response => {
      this.props.checkSession()
    })
  }

  render () {
    const username = this.state.username
    const password = this.state.password

    return (
      <div>
        <h2>Please, sign in...</h2>
        <form onSubmit={this.signin}>
          <input type="text" name="username" placeholder="username"
            value={username} onChange={this.updateInput}
          />
          <input type="password" name="password" placeholder="password"
            value={password} onChange={this.updateInput}
          />
          <button type="submit" disabled={username.match(/^\s*$/) || password.match(/^\s*$/)}>
            sign in
          </button>
        </form>
      </div>
    )
  }
}
