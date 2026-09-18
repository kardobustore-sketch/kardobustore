KARDOBU STORE FINAL

1. Jalankan SQL database KARDOBU yang diberikan di chat pada Supabase SQL Editor.
2. Buka index.html dan admin.html.
3. Cari:
   const SUPABASE_KEY="PASTE_PUBLISHABLE_KEY_HERE";
   lalu isi dengan Publishable Key Supabase milik KARDOBU.
4. Buat akun admin melalui Supabase Authentication > Users.
5. Upload index.html, admin.html, style.css ke GitHub Pages/hosting.
6. Buka admin.html untuk mengelola produk dan pesanan.

CATATAN:
- Jangan memasukkan service_role/secret key ke website.
- Nomor WhatsApp toko diatur dari admin setelah login.
- Pembelian disimpan ke Supabase lalu membuka WhatsApp dengan pesan order otomatis.
- Untuk produksi, gunakan RLS dengan admin role khusus seperti SQL keamanan yang disiapkan.
