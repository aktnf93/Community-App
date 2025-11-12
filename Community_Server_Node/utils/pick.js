// example.
// import { pick } from './utils/pick.js';
// const obj = pick(req.body, ['id', 'name', 'remark']);


/**
 * example: " const obj = pick(req.body, ['id', 'name', 'remark']); "
 * @param {Object} src - 받은 항목: req.body | ex: { id, age }
 * @param {string[]} keys - 가져올 항목: columns | ex: ['id']
 * @returns {Object} - 필터링된 항목: object | ex: { id }
 */
const pick = (src, keys) => {
    return Object.fromEntries(
        Object.entries(src || {})
            .filter(([k]) => keys.includes(k))
    );
}

module.exports = pick;