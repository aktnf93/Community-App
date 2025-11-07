// example.
// import { pick } from './utils/pick.js';
// const obj = pick(req.body, ['id', 'name', 'remark']);


/**
 * example: " const obj = pick(req.body, ['id', 'name', 'remark']); "
 * @param {Object} src - req.body | ex: { id, age }
 * @param {string[]} keys - columns | ex: ['id']
 * @returns {Object} - object | ex: { id }
 */
const pick = (src, keys) => {
    return Object.fromEntries(
        Object.entries(src || {})
            .filter(([k]) => keys.includes(k))
    );
}

module.exports = pick;