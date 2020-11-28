import { combineReducers } from 'redux';
import { DECREMENT_COUNT, INCREMENT_COUNT, SET_AMOUNT } from './actions'

const countReducer = (state = 0, { type, payload }) => {
    switch (type) {
        case INCREMENT_COUNT:
            return state + payload
        case DECREMENT_COUNT:
            return state - payload
        default:
            return state;
    }
};

const amountReducer = (state = 1, { type, payload }) => {
    switch (type) {
        case SET_AMOUNT:
            return payload
        default:
            return state;
    }
};

const rootReducer = combineReducers({
    count: countReducer,
    amount: amountReducer
});

export default rootReducer;