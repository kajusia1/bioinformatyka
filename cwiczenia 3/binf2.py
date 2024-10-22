def TFIDF(documents, splitowanie = False):
    import pandas as pd
    
    if splitowanie == True:
        bg = [x.split(' ') for x in documents]
    else:
        bg = documents
                    
    N = len(documents)
    unique_words = set(sum(bg, []))
    num_of_words = []

    for i in range(N):
        nw = dict.fromkeys(unique_words,0)
        for word in bg[i]:
            nw[word]+=1
        
        num_of_words+=[nw]
                   
    def computeTF(wordDict):
        tfDict = {}
        M = wordDict.values()
        for word, count in wordDict.items():
            tfDict[word] = count/max(M)
        return tfDict
                   
    tf = [computeTF(num_of_words[i]) for i in range(len(bg))]

                   
    def computeIDF(documents):
        import math
        N = len(documents)
    
        idfDict = dict.fromkeys(documents[0].keys(),0)
        for document in documents:
            for word, val in document.items():
                if val>0:
                    idfDict[word]+=1
        for word, val in idfDict.items():
            idfDict[word] = math.log2(N/float(val))
        return idfDict
                   
    idfs = computeIDF(num_of_words)

    def computeTFIDF(tfBag, idfs):
        tfidf = {}
        for word, val in tfBag.items():
            tfidf[word] = val*idfs[word]
        return tfidf           

    df = pd.DataFrame([computeTFIDF(tf[i], idfs) for i in range(N)])
    
    return df