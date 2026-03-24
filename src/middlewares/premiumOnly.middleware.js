export function premiumOnly(req, res, next) {
  if (!req.user?.premium) {
    return res.status(403).json({
      message: "Funcionalidade disponível apenas para usuários Premium"
    });
  }
  next();
}
