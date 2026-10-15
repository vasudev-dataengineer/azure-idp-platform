from fastapi import FastAPI

app = FastAPI(title="E-Commerce Product Service")

@app.get("/")
def home():
    return {"message": "Product Service is running"}

@app.get("/health")
def health():
    return {"status": "healthy"}

@app.get("/products")
def get_products():
    return [
        {"id": 1, "name": "Galaxy Smartphone", "price": 79999},
        {"id": 2, "name": "Smart TV", "price": 54999},
        {"id": 3, "name": "Wireless Earbuds", "price": 9999}
    ]