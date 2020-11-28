import React, { Component } from 'react'
import { connect } from 'react-redux'
import { increment, decrement, setAmount } from './actions'

export class Counter extends Component {
    render() {
        const {
            amount,
            count,
            increment,
            decrement,
            setAmount
        } = this.props;

        return (
            <div className="ui middle aligned center aligned grid">
                <div className="ten wide column">
                    <div className="row" style={{ padding: '10px' }}>
                        <p>Count: {count}</p>
                    </div>
                    <div className="row" style={{ padding: '10px' }}>
                        <div className="ui input">
                            <input
                                type="text"
                                placeholder="Amount"
                                onChange={event => {
                                    const amount = parseInt(event.target.value)
                                    if (amount) setAmount(amount);
                                }}
                            />
                        </div>
                    </div>
                    <div className="row" style={{ padding: '10px' }}>
                        <button
                            className="ui primary button"
                            onClick={() => increment(amount)}
                        >
                            Increment by {amount}
                        </button>
                    </div>
                    <div className="row" style={{ padding: '10px' }}>
                        <button
                            className="ui button"
                            onClick={() => decrement(amount)}
                        >
                            Decrement by {amount}
                        </button>
                    </div>
                </div>
            </div >
        )
    }
}

const mapStateToProps = state => ({
    count: state.count,
    amount: state.amount
})

const mapDispatchToProps = {
    increment,
    decrement,
    setAmount
}

export default connect(mapStateToProps, mapDispatchToProps)(Counter)
