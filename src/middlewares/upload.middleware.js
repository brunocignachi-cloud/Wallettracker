import multer from "multer";
import fs from "fs";
import path from "path";

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const { expenseId } = req.params;

    if (!expenseId) {
      return cb(new Error("expenseId não informado na rota"));
    }

    const dir = path.join(
      process.cwd(),
      "uploads",
      "expenses",
      expenseId
    );

    fs.mkdirSync(dir, { recursive: true });
    cb(null, dir);
  },

  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    cb(null, `${Date.now()}${ext}`);
  }
});

const allowedImageExtensions = [".jpg", ".jpeg", ".png", ".webp"];
const allowedVideoExtensions = [".mp4", ".mov", ".avi", ".mkv"];

const fileFilter = (req, file, cb) => {
  const ext = path.extname(file.originalname).toLowerCase();

  const isImage =
    file.mimetype.startsWith("image/") ||
    allowedImageExtensions.includes(ext);

  const isVideo =
    file.mimetype.startsWith("video/") ||
    allowedVideoExtensions.includes(ext);

  if (isImage || isVideo) {
    cb(null, true);
  } else {
    cb(new Error("Tipo de arquivo não suportado"), false);
  }
};

export const upload = multer({
  storage,
  fileFilter,
  limits: {
    fileSize: 20 * 1024 * 1024, // 20MB
  }
});