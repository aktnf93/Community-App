const route_get = async (req, res, next, tb) => {
    try {
        const data = pick(req.body, tb.get);
        const result = await select_query(req, tb.view, data);
        res.locals.dbResult = result;
        next();
    } 
    catch (err) {
        next(err);
    }
};