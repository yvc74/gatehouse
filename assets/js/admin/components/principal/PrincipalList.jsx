
import React from "react"
import server from "../../server"
import Dispatcher from "../../dispatcher"

export default class PrincipalList extends React.Component {

  constructor(props) {
    super(props)
    this.state = { principals: [] }
  }

  loadList() {
    server.get('principal').then( principals => {
      if(this.mounted) {
        this.setState({ principals: principals })
      }
    })
  }

  componentDidMount() {
    this.mounted = true
    this.loadList()
    this.principalCreatedCallback = Dispatcher.principalCreated.addObserver(() => this.loadList())
    this.principalDeletedCallback = Dispatcher.principalDeleted.addObserver(() => this.loadList())
  }

  componentWillUnmount(){
    this.mounted = false
    Dispatcher.principalCreated.removeObserver(this.principalCreatedCallback)
    Dispatcher.principalDeleted.removeObserver( this.principalDeletedCallback )
  }

  onItemClicked(principalId) {
    Dispatcher.principalSelected.update(principalId)
  }

  render() {
    var principals = this.state.principals

    return (
      <div className="list-group">
          {principals.map(p => <a href="#/principal" className="list-group-item"
               key={p.id} onClick={() => this.onItemClicked(p.id)}>{p.email}</a>)}
      </div>
       )
  }
}
