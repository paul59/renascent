
import allegro5.allegro_font;

import main : messageFont;
import globals;







struct MessageLine{
    
    MessageColor color;
    string message;
}

MessageLine[MessageBufferSize] messageLines;


void addMessage(MessageColor color, string mess)
{
    
 
  
    // method for adding a new message:
    // split the output string to words
    // try to add word, check if pixel width exceeds limit
    // if width exceeds limit
    //      add message with string so far
    //      scroll messages up
    //      add last word to start of new line
    // continue 
 
  
    import std.array : split;
    import std.string : toStringz;
    import globals : MsgBoxWidth;
    
    string[] words;
    words = split(mess);
    
    string msgLine;
    int currWidth;
   
    foreach(word; words)
    {
        word ~= " ";
        int wordWidth = al_get_text_width(messageFont, word.toStringz);
        if(currWidth + wordWidth >= MsgBoxWidth)
        {
           //add the line so far
           scrollMessages();
           messageLines[MessageBufferSize - 1] = MessageLine(color, msgLine);
           //reset width and line text
           currWidth = 0;
           msgLine = word;
            
        } else
        {
        
            //add word to line to output and update width
            msgLine ~= word;
            currWidth += wordWidth;
        }
    }
    
    
    // add new message to end of list
    scrollMessages();
    messageLines[MessageBufferSize - 1] = MessageLine(color, msgLine);
    


    
}


void scrollMessages()
{
    
    // scroll existing messages up
    foreach(i; 1..MessageBufferSize)
    {
        messageLines[i-1] = messageLines[i];
    } 
       
}
