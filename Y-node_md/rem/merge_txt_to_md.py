import os

def merge_txt_to_md(output_file):
    """
    将当前目录下的所有txt文件合并成一个md文件
    :param output_file: 输出的md文件路径
    """
    with open(output_file, 'w', encoding='utf-8') as md_file:
        # 获取当前目录下所有txt文件（按文件名排序）
        txt_files = sorted([f for f in os.listdir('.') if f.endswith('.txt')])
        
        for filename in txt_files:
            # 提取文件名（不带扩展名）作为标题
            title = os.path.splitext(filename)[0]
            
            # 写入Markdown标题
            md_file.write(f"# {title}\n\n")
            
            # 读取并写入txt内容
            with open(filename, 'r', encoding='utf-8') as txt_file:
                content = txt_file.read()
                md_file.write(content + "\n\n")
                
            print(f"已合并文件: {filename}")

if __name__ == "__main__":
    output_file = 'output.md'  # 默认输出文件名
    print(f"开始合并当前目录下的txt文件...")
    merge_txt_to_md(output_file)
    print(f"合并完成！结果已保存至 {output_file}")