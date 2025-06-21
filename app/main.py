from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Deply V8 :) It is long way"}