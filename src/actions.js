export const INCREMENT_COUNT = 'INCREMENT_COUNT';
export const DECREMENT_COUNT = 'DECREMENT_COUNT';
export const SET_AMOUNT = 'SET_AMOUNT';

export const increment = amount => {
    return {
        type: INCREMENT_COUNT,
        payload: amount
    }
};

export const decrement = amount => {
    return {
        type: DECREMENT_COUNT,
        payload: amount
    }
};

export const setAmount = amount => {
    return {
        type: SET_AMOUNT,
        payload: amount
    }
};