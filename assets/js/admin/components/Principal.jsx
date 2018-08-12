import React from "react"
import Email from "./principal/Email"
import Password from "./principal/Password"
import Roles from "./principal/Roles"

export default class Principal extends React.Component {
  render() {
    return (
        <div className="card">
          <div className="card-body">
            <div className="container-fluid">
              <div className="row">
                <div className="col-xs-6">
                  <Email/>
                  <Password/>
                </div>
                <div className="col-xs-6">
                  <Roles/>
                </div>
              </div>
            </div>
          </div>
        </div>
       )
  }
}
