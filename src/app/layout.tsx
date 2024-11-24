import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "企业数字化服务解决方案",
  description: "提供专业的企业建站、数字化办公等服务",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="zh-CN">
      <body className={`${inter.className} antialiased`}>
        <div className="min-h-screen bg-gradient-to-b from-gray-50 to-white">
          {children}
        </div>
      </body>
    </html>
  );
}
