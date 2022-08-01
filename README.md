//總結：

//預設宣告Strong，強行擁有，只要有一方沒有釋放，就會一直保留

//所以在釋放前，需要把所有依賴都先釋放掉，才能避免記憶體洩漏(memory leak)

//-----------------------

//宣告使用Weak，弱引用，只要(當下瞬間)，沒有任何人引用就會直接被釋放

//所以在內部宣告使用，因為宣告完後，沒有其他引用，宣告完就會直接被釋放

//可以這樣使用：內部宣告Weak，外部給予參考，外部參考釋放他跟的釋放

//-----------------------

//宣告使用unowned，不強行擁有，互相引用時，引用時如果為unowned，不會強行握住對方，不讓對方釋放

//因此使用時，應該注意使用unowned的那方，盡量不要外曝，否則程式碼一多，忘記或漏檢查，先前已經釋放了，再去呼叫他，就直接閃退了
