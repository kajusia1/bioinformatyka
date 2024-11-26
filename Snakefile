assemblies, = glob_wildcards('genomes_test/{assembly}.fna')
print(assemblies)
    
rule all:
    input:
        'output/tree.png'
        
        
rule blastn:
    conda:
        'envs/blast.yml'
    params:
        outfmt = 6,
        cols   = 'sseqid sseq qcovs evalue'
    input:
        query   = 'input/rpoB.fna',
        subject = 'genomes_test/{assembly}.fna'
    output:
        'output/blastn/{assembly}.tsv'
    log:
        'log/blastn/{assembly}.log'
    shell:
        '''blastn -outfmt     "{params.outfmt} {params.cols}" \
                  -query    {input.query}                          \
                  -subject  {input.subject}                          \
                  -out      {output}                          \
                   > {log} 2>&1
        '''
        
        
rule filter:
    conda:
        'envs/pandas.yml'
    params:
        qcovs = 100,
        cols  = 'sseqid sseq qcovs evalue'
    input:
        'output/blastn/{assembly}.tsv'
    output:
        'output/filtered/{assembly}.tsv'
    log:
        'log/filtered/{assembly}.log'
    shell:
        '''scripts/filter.py	--qcovs		{params.qcovs} \
                  		--cols		"{params.cols}" \
                  		--input		{input} \
                  		--output	{output} \
                   		> {log} 2>&1
        '''
    
    
rule convert:
    input:
        'output/filtered/{assembly}.tsv'
    output:
        'output/converted/{assembly}.tsv'
    log:
        'log/converted/{assembly}.log'
    shell:
        '''scripts/convert.py	--input		{input} \
                  		--output	{output} \
                   		> {log} 2>&1
        '''
    
    
rule merge:
    params:
        mask = rules.convert.output[0].replace('{assembly}', '*')
    input:
        expand(rules.convert.output, assembly=assemblies)
    output:
        'output/merged.fna'
    log:
        'log/merge.log'
    shell:
        'cat {params.mask} > {output} 2> {log}'
        
        
rule clustalo:
    conda:
        'envs/clustalo.yml'
    params:
        infmt  = 'fasta',
        outfmt = 'fasta'
    threads:
        8
    input:
        'output/merged.fna'
    output:
        'output/clustalo.fna'
    log:
        'log/clustalo.log'
    shell:
        '''clustalo --infmt    {params.infmt} \
                    --outfmt   {params.outfmt} \
                    --threads  {threads} \
                    --infile   {input} \
                    --outfile  {output} \
                      > {log} 2>&1
        '''
        
tree_name = 'rpoB'
        
rule raxml:
    conda:
        'envs/raxml.yml'
    threads:
        8
    input:
        rules.clustalo.output
    output:
        'output/RAxML_bestTree.' + tree_name
    log:
        'log/raxml.log'
    params:
        model  = 'GTRCAT',
        outdir = os.getcwd() + '/output',
        name   = tree_name
    shell:
        '''raxmlHPC-PTHREADS-SSE3 \
               -p 1               \
               -T {threads}       \
               -s {input}         \
               -w {params.outdir} \
               -n {params.name}   \
               -m {params.model}  \
                > {log} 2>&1
        '''
        
rule drawtree:
    conda:
        'envs/ete3.yml'
    input:
        rules.raxml.output
    output:
        'output/tree.png'
    log:
        'log/drawtree.log'
    shell:
        '''scripts/drawtree_text.py --input  {input}  \
                               --output {output} \
                                 > {log} 2>&1
        '''

