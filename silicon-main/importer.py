import json, requests

URL = "https://pbbfbtuycmjwqncvaamw.supabase.co"
KEY = "sb_publishable_ujLUAD3rqCXxiy_lJ44-Rg_IhVwu3Qf"
HEADERS = {
    "apikey": KEY,
    "Content-Type": "application/json",
    "Prefer": "resolution=ignore-duplicates,return=minimal",
}

with open("products_300.json") as f:
    products = json.load(f)     # will crash if file is invalid — that's good, catches truncation

clean = []
for p in products:
    clean.append({
        "id": p["id"],
        "name": p["name"],
        "price": float(p["price"]) if p.get("price") not in (None, "") else 0,
        "cost_price": float(p["cost_price"]) if p.get("cost_price") not in (None, "") else 0,
        "stock": int(p.get("stock") or 0),
        "category": p.get("category"),
        "barcode": p.get("barcode") or None,
        "created_at": p.get("created_at"),
    })

for i in range(0, len(clean), 100):
    chunk = clean[i:i+100]
    r = requests.post(f"{URL}/rest/v1/products", headers=HEADERS, json=chunk, timeout=30)
    print(f"Batch {i//100+1}: {r.status_code}")
    if r.status_code not in (200, 201):
        print(r.text[:300])