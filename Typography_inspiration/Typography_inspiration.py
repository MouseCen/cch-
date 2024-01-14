#!/usr/bin/env python
# coding: utf-8

# In[2]:


import cv2
import numpy as np
from PIL import ImageFont, ImageDraw, Image
import textwrap
import random
import torch
from transformers import AutoTokenizer, AutoModelForTokenClassification
from seqeval.metrics.sequence_labeling import get_entities


tokenizer = AutoTokenizer.from_pretrained("shibing624/bert4ner-base-chinese")
model = AutoModelForTokenClassification.from_pretrained("shibing624/bert4ner-base-chinese")
label_list = ['I-ORG', 'B-LOC', 'O', 'B-ORG', 'I-LOC', 'I-PER', 'B-TIME', 'I-TIME', 'B-PER']


rows = 2
cols = 3
margin = 10
border_thickness = 0
show_grid = True

def get_entity(sentence):
    tokens = tokenizer.tokenize(sentence)
    inputs = tokenizer.encode(sentence, return_tensors="pt")
    with torch.no_grad():
        outputs = model(inputs).logits
    predictions = torch.argmax(outputs, dim=2)
    char_tags = [(token, label_list[prediction]) for token, prediction in zip(tokens, predictions[0].numpy())][1:-1]

    pred_labels = [i[1] for i in char_tags]
    entities = []
    line_entities = get_entities(pred_labels)
    for i in line_entities:
        word = sentence[i[1]: i[2] + 1]
        entity_type = i[0]
        entities.append((word, entity_type))

    return entities


def create_rectangular_grid(img, border_thickness):
 
    rect_width = (img.shape[1] - (cols + 1) * margin) // cols
    rect_height = (img.shape[0] - (rows + 1) * margin) // rows


    grid_img = np.ones_like(img)*255


    if border_thickness > 0:
        for row in range(rows):
            for col in range(cols):
                x = margin + col * (rect_width + margin)
                y = margin + row * (rect_height + margin)
                cv2.rectangle(grid_img, (x, y), (x + rect_width, y + rect_height), (0,0,0), border_thickness)

    return grid_img

def get_random_rectangle(img):

    rect_width = (img.shape[1] - (cols + 1) * margin) // cols
    rect_height = (img.shape[0] - (rows + 1) * margin) // rows

    row = random.randint(0, rows - 1)
    col = random.randint(0, cols - 1)
    x = margin + col * (rect_width + margin)
    y = margin + row * (rect_height + margin)

    return x, y, x + rect_width, y + rect_height

def draw_text_in_rectangle(img, text, top_left, bottom_right, font_path, font_size):
  
    pil_img = Image.fromarray(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))

    draw = ImageDraw.Draw(pil_img)

    
    font = ImageFont.truetype(font_path, font_size)

    rect_width = bottom_right[0] - top_left[0]
    rect_height = bottom_right[1] - top_left[1]

 
    char_width, char_height = draw.textsize('测试', font=font)

   
    chars_per_line = rect_width // char_width

    
    lines = textwrap.wrap(text, width=2 * chars_per_line)

   
    y = top_left[1]
    for line in lines:
        if y + char_height <= bottom_right[1]: 
            draw.text((top_left[0], y), line, font=font, fill=(0, 0, 0, 0))
            y += char_height

   
    img = cv2.cvtColor(np.array(pil_img), cv2.COLOR_RGB2BGR)

    return img




# In[12]:



img = np.ones((800, 600, 3), np.uint8) 


num_paragraphs = int(input("请输入需要嵌入矩形的文字段落数："))


paragraphs = []
entities_list = []
for i in range(num_paragraphs):
    paragraph = input(f"请输入第{i+1}段文本：")
    entities = get_entity(paragraph)
    entity_text = [entity for entity in entities]
    paragraphs.append(paragraph) 
    entities_list.extend(entity_text) 


used_rectangles = []


show_original = True
show_LOC = True
show_PER = True
show_ORG = True
show_TIME = True


original_font_size = 15
entity_font_size = 60


while True:
   
    grid_img = create_rectangular_grid(img, border_thickness) if show_grid else img.copy()

    for i, text in enumerate(paragraphs):
       
        for _ in range(500): 
            x1, y1, x2, y2 = get_random_rectangle(img)
            if (x1, y1, x2, y2) not in used_rectangles:
                used_rectangles.append((x1, y1, x2, y2))
                break

        if show_original:
            grid_img = draw_text_in_rectangle(grid_img, text, (x1, y1), (x2, y2), "C:\\Windows\\Fonts\\simsun.ttc", original_font_size)

    
    for i, entity in enumerate(entities_list):
        
        for _ in range(1000):  
            x1, y1, x2, y2 = get_random_rectangle(img)
            if (x1, y1, x2, y2) not in used_rectangles:
                used_rectangles.append((x1, y1, x2, y2))
                break

    
        if (entity[1] == 'LOC' and show_LOC) or (entity[1] == 'PER' and show_PER) or (entity[1] == 'ORG' and show_ORG) or (entity[1] == 'TIME' and show_TIME):
            grid_img = draw_text_in_rectangle(grid_img, entity[0], (x1, y1), (x2, y2), "C:\\Windows\\Fonts\\simsun.ttc", entity_font_size)

  
    cv2.imshow('Grid', grid_img)

    key = cv2.waitKey(0) & 0xFF

    if key == ord('8'):
        rows += 1
    elif key == ord('2'):
        rows = max(1, rows - 1)
    elif key == ord('4'):
        cols = max(1, cols - 1)
    elif key == ord('6'):
        cols += 1
    elif key == ord(' '): 
        border_thickness = 0 if border_thickness == 1 else 1  
    elif key == ord('h'):  
        show_LOC = not show_LOC
    elif key == ord('j'):  
        show_PER = not show_PER
    elif key == ord('k'):  
        show_ORG = not show_ORG
    elif key == ord('l'):  
        show_TIME = not show_TIME
    elif key == ord('7'):  
        original_font_size = max(1, original_font_size - 1)
    elif key == ord('9'):  
        original_font_size += 1
    elif key == ord('1'):  
        entity_font_size = max(1, entity_font_size - 1)
    elif key == ord('3'):  
        entity_font_size += 1
 
    elif key == 27:
        break

cv2.destroyAllWindows()


# In[ ]:




