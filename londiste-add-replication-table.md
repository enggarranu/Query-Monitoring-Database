replikasi table public.ws_product_brand dari 172.21.252.154 (tokopedia-product) ke 172.21.253.71 (trove-lama)

1. masuk ke trove lama lalu cek tablenya, kalo ada isinya truncate aja biar si londis nya yang kopi ulang.
kalo ngga ada tablenya bikin manual (walaupun otomatis bisa tapi kadang nyangkut ref: bang Rizky R) 

2.  ssh ke tokopedia-product | lalu masuk sebagai postgres | lalu ke folder tkpd
cek status replikasi ke trove
postgres@postgres-172-21-252-154:~/tkpd$  londiste3 trove-71.ini status
Queue: tkp_products_queue   Local node: trove-71

product-154 (root)
  |                           Tables: 3/0/0
  |                           Lag: 0s, Tick: 2669360
  +--: trove-71 (leaf)
                              Tables: 3/0/0
                              Lag: 0s, Tick: 2669360


nah disiti keliatan kelo produsernya si product-154
jadi cek table2 yang teregister di product-154
postgres@postgres-172-21-252-154:~/tkpd$ londiste3 product-154.ini tables
Tables on node
table_name                 merge_state      table_attrs
-------------------------  ---------------  ---------------
public.ws_brand            ok               
public.ws_product_alias    ok               
public.ws_product_variant  ok   

3. tambahin table ws_product_brand dengan perintah berikut :
postgres@postgres-172-21-252-154:~/tkpd$ londiste3 product-154.ini add-table ws_product_brand
2019-01-18 16:43:30,532 14156 INFO Table added: public.ws_product_brand

4. cek ws_product_brand yang barusan di add di product-154
postgres@postgres-172-21-252-154:~/tkpd$ londiste3 product-154.ini tables
Tables on node
table_name                 merge_state      table_attrs
-------------------------  ---------------  ---------------
public.ws_brand            ok               
public.ws_product_alias    ok               
public.ws_product_brand    ok               
public.ws_product_variant  ok               

nah.. ws_product_brand udah ada kan..

5. sekarang cek lagi statusnya si product-154
postgres@postgres-172-21-252-154:~/tkpd$ londiste3 product-154.ini status
Queue: tkp_products_queue   Local node: product-154

product-154 (root)
  |                           Tables: 4/0/0
  |                           Lag: 2s, Tick: 2669422
  +--: trove-71 (leaf)
                              Tables: 3/0/1
                              Lag: 2s, Tick: 2669422


perhatiin Tables: 4/0/0 di product-154 udah ada 4 table tapi di trove-71 masih 3 dan 1 yang belum terproses

====================================================================================
6. sekarang tambahin di trove-71
postgres@postgres-172-21-252-154:~/tkpd$  londiste3 trove-71.ini add-table ws_product_brand
2019-01-18 16:45:52,537 25533 INFO Table added: public.ws_product_brand

7. Cek statusnya si trove-71
postgres@postgres-172-21-252-154:~/tkpd$  londiste3 trove-71.ini status
Queue: tkp_products_queue   Local node: trove-71

product-154 (root)
  |                           Tables: 4/0/0
  |                           Lag: 0s, Tick: 2669468
  +--: trove-71 (leaf)
                              Tables: 3/1/0
                              Lag: 3s, Tick: 2669467
perhatiin Tables: 3/1/0 artinya 1 yang proses

kalo diliat merge_state nya pasti in-copy

postgres@postgres-172-21-252-154:~/tkpd$  londiste3 trove-71.ini tables
Tables on node
table_name                 merge_state      table_attrs
-------------------------  ---------------  ---------------
public.ws_brand            ok               
public.ws_product_alias    ok               
public.ws_product_brand    in-copy          
public.ws_product_variant  ok 

tuhkan in-copy..


8 kalo udah selesai semuanya. merge_statenya akan 'OK'
postgres@postgres-172-21-252-154:~/tkpd$  londiste3 trove-71.ini tables
Tables on node
table_name                 merge_state      table_attrs
-------------------------  ---------------  ---------------
public.ws_brand            ok               
public.ws_product_alias    ok               
public.ws_product_brand    ok               
public.ws_product_variant  ok           