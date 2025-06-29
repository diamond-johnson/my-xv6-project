
kernelmemfs:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 70 24 19 80       	mov    $0x80192470,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 30 2d 10 80       	mov    $0x80102d30,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 75 18 80       	mov    $0x80187554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 60 6f 10 80       	push   $0x80106f60
80100051:	68 20 75 18 80       	push   $0x80187520
80100056:	e8 55 40 00 00       	call   801040b0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c bc 18 80       	mov    $0x8018bc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c bc 18 80 1c 	movl   $0x8018bc1c,0x8018bc6c
8010006a:	bc 18 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 bc 18 80 1c 	movl   $0x8018bc1c,0x8018bc70
80100074:	bc 18 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c bc 18 80 	movl   $0x8018bc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 6f 10 80       	push   $0x80106f67
80100097:	50                   	push   %eax
80100098:	e8 e3 3e 00 00       	call   80103f80 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 bc 18 80       	mov    0x8018bc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 bc 18 80    	mov    %ebx,0x8018bc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 b9 18 80    	cmp    $0x8018b9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave
801000c2:	c3                   	ret
801000c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801000ca:	00 
801000cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 75 18 80       	push   $0x80187520
801000e4:	e8 b7 41 00 00       	call   801042a0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 bc 18 80    	mov    0x8018bc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c bc 18 80    	cmp    $0x8018bc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c bc 18 80    	cmp    $0x8018bc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c bc 18 80    	mov    0x8018bc6c,%ebx
80100126:	81 fb 1c bc 18 80    	cmp    $0x8018bc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c bc 18 80    	cmp    $0x8018bc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 75 18 80       	push   $0x80187520
80100162:	e8 d9 40 00 00       	call   80104240 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 4e 3e 00 00       	call   80103fc0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 ff 6c 00 00       	call   80106e90 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 6e 6f 10 80       	push   $0x80106f6e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 9d 3e 00 00       	call   80104060 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave
  iderw(b);
801001d4:	e9 b7 6c 00 00       	jmp    80106e90 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 7f 6f 10 80       	push   $0x80106f7f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801001ed:	00 
801001ee:	66 90                	xchg   %ax,%ax

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 5c 3e 00 00       	call   80104060 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 0c 3e 00 00       	call   80104020 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 75 18 80 	movl   $0x80187520,(%esp)
8010021b:	e8 80 40 00 00       	call   801042a0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2c                	jne    8010025c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 53 54             	mov    0x54(%ebx),%edx
80100233:	8b 43 50             	mov    0x50(%ebx),%eax
80100236:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100239:	8b 53 54             	mov    0x54(%ebx),%edx
8010023c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010023f:	a1 70 bc 18 80       	mov    0x8018bc70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c bc 18 80 	movl   $0x8018bc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 bc 18 80       	mov    0x8018bc70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 bc 18 80    	mov    %ebx,0x8018bc70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 75 18 80 	movl   $0x80187520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 d2 3f 00 00       	jmp    80104240 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 86 6f 10 80       	push   $0x80106f86
80100276:	e8 05 01 00 00       	call   80100380 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 e7 15 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 bf 18 80 	movl   $0x8018bf20,(%esp)
801002a0:	e8 fb 3f 00 00       	call   801042a0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 bf 18 80       	mov    0x8018bf00,%eax
801002b5:	39 05 04 bf 18 80    	cmp    %eax,0x8018bf04
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 bf 18 80       	push   $0x8018bf20
801002c8:	68 00 bf 18 80       	push   $0x8018bf00
801002cd:	e8 4e 3a 00 00       	call   80103d20 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 bf 18 80       	mov    0x8018bf00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 bf 18 80    	cmp    0x8018bf04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 79 33 00 00       	call   80103660 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 bf 18 80       	push   $0x8018bf20
801002f6:	e8 45 3f 00 00       	call   80104240 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 9c 14 00 00       	call   801017a0 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 bf 18 80    	mov    %edx,0x8018bf00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 be 18 80 	movsbl -0x7fe74180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 bf 18 80       	push   $0x8018bf20
8010034c:	e8 ef 3e 00 00       	call   80104240 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 46 14 00 00       	call   801017a0 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 bf 18 80       	mov    %eax,0x8018bf00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010037b:	00 
8010037c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli
  cons.locking = 0;
80100389:	c7 05 54 bf 18 80 00 	movl   $0x0,0x8018bf54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 32 22 00 00       	call   801025d0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 8d 6f 10 80       	push   $0x80106f8d
801003a7:	e8 04 03 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 fb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 a7 73 10 80 	movl   $0x801073a7,(%esp)
801003bc:	e8 ef 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 03 3d 00 00       	call   801040d0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 a1 6f 10 80       	push   $0x80106fa1
801003dd:	e8 ce 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 bf 18 80 01 	movl   $0x1,0x8018bf58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801003fc:	00 
801003fd:	8d 76 00             	lea    0x0(%esi),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
80100409:	3d 00 01 00 00       	cmp    $0x100,%eax
8010040e:	0f 84 cc 00 00 00    	je     801004e0 <consputc.part.0+0xe0>
    uartputc(c);
80100414:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100417:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010041c:	89 c3                	mov    %eax,%ebx
8010041e:	50                   	push   %eax
8010041f:	e8 8c 55 00 00       	call   801059b0 <uartputc>
80100424:	b8 0e 00 00 00       	mov    $0xe,%eax
80100429:	89 fa                	mov    %edi,%edx
8010042b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042c:	be d5 03 00 00       	mov    $0x3d5,%esi
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100434:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100437:	89 fa                	mov    %edi,%edx
80100439:	b8 0f 00 00 00       	mov    $0xf,%eax
8010043e:	c1 e1 08             	shl    $0x8,%ecx
80100441:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100442:	89 f2                	mov    %esi,%edx
80100444:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100445:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
80100448:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	75 76                	jne    801004c8 <consputc.part.0+0xc8>
    pos += 80 - pos%80;
80100452:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100457:	f7 e2                	mul    %edx
80100459:	c1 ea 06             	shr    $0x6,%edx
8010045c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010045f:	c1 e0 04             	shl    $0x4,%eax
80100462:	8d 70 50             	lea    0x50(%eax),%esi
  if(pos < 0 || pos > 25*80)
80100465:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
8010046b:	0f 8f 2f 01 00 00    	jg     801005a0 <consputc.part.0+0x1a0>
  if((pos/80) >= 24){  // Scroll up.
80100471:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100477:	0f 8f c3 00 00 00    	jg     80100540 <consputc.part.0+0x140>
  outb(CRTPORT+1, pos>>8);
8010047d:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
8010047f:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100486:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100489:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048c:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100491:	b8 0e 00 00 00       	mov    $0xe,%eax
80100496:	89 da                	mov    %ebx,%edx
80100498:	ee                   	out    %al,(%dx)
80100499:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010049e:	89 f8                	mov    %edi,%eax
801004a0:	89 ca                	mov    %ecx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b8 0f 00 00 00       	mov    $0xf,%eax
801004a8:	89 da                	mov    %ebx,%edx
801004aa:	ee                   	out    %al,(%dx)
801004ab:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004af:	89 ca                	mov    %ecx,%edx
801004b1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b2:	b8 20 07 00 00       	mov    $0x720,%eax
801004b7:	66 89 06             	mov    %ax,(%esi)
}
801004ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004bd:	5b                   	pop    %ebx
801004be:	5e                   	pop    %esi
801004bf:	5f                   	pop    %edi
801004c0:	5d                   	pop    %ebp
801004c1:	c3                   	ret
801004c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004c8:	0f b6 db             	movzbl %bl,%ebx
801004cb:	8d 70 01             	lea    0x1(%eax),%esi
801004ce:	80 cf 07             	or     $0x7,%bh
801004d1:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004d8:	80 
801004d9:	eb 8a                	jmp    80100465 <consputc.part.0+0x65>
801004db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e0:	83 ec 0c             	sub    $0xc,%esp
801004e3:	be d4 03 00 00       	mov    $0x3d4,%esi
801004e8:	6a 08                	push   $0x8
801004ea:	e8 c1 54 00 00       	call   801059b0 <uartputc>
801004ef:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f6:	e8 b5 54 00 00       	call   801059b0 <uartputc>
801004fb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100502:	e8 a9 54 00 00       	call   801059b0 <uartputc>
80100507:	b8 0e 00 00 00       	mov    $0xe,%eax
8010050c:	89 f2                	mov    %esi,%edx
8010050e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010050f:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100514:	89 da                	mov    %ebx,%edx
80100516:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100517:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010051a:	89 f2                	mov    %esi,%edx
8010051c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100521:	c1 e1 08             	shl    $0x8,%ecx
80100524:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100525:	89 da                	mov    %ebx,%edx
80100527:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100528:	0f b6 f0             	movzbl %al,%esi
    if(pos > 0) --pos;
8010052b:	83 c4 10             	add    $0x10,%esp
8010052e:	09 ce                	or     %ecx,%esi
80100530:	74 5e                	je     80100590 <consputc.part.0+0x190>
80100532:	83 ee 01             	sub    $0x1,%esi
80100535:	e9 2b ff ff ff       	jmp    80100465 <consputc.part.0+0x65>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 ca 3e 00 00       	call   80104430 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 25 3e 00 00       	call   801043a0 <memset>
  outb(CRTPORT+1, pos);
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 06 ff ff ff       	jmp    8010048c <consputc.part.0+0x8c>
80100586:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010058d:	00 
8010058e:	66 90                	xchg   %ax,%ax
80100590:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100594:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100599:	31 ff                	xor    %edi,%edi
8010059b:	e9 ec fe ff ff       	jmp    8010048c <consputc.part.0+0x8c>
    panic("pos under/overflow");
801005a0:	83 ec 0c             	sub    $0xc,%esp
801005a3:	68 a5 6f 10 80       	push   $0x80106fa5
801005a8:	e8 d3 fd ff ff       	call   80100380 <panic>
801005ad:	8d 76 00             	lea    0x0(%esi),%esi

801005b0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005b0:	55                   	push   %ebp
801005b1:	89 e5                	mov    %esp,%ebp
801005b3:	57                   	push   %edi
801005b4:	56                   	push   %esi
801005b5:	53                   	push   %ebx
801005b6:	83 ec 18             	sub    $0x18,%esp
801005b9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005bc:	ff 75 08             	push   0x8(%ebp)
801005bf:	e8 bc 12 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
801005c4:	c7 04 24 20 bf 18 80 	movl   $0x8018bf20,(%esp)
801005cb:	e8 d0 3c 00 00       	call   801042a0 <acquire>
  for(i = 0; i < n; i++)
801005d0:	83 c4 10             	add    $0x10,%esp
801005d3:	85 f6                	test   %esi,%esi
801005d5:	7e 25                	jle    801005fc <consolewrite+0x4c>
801005d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005da:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005dd:	8b 15 58 bf 18 80    	mov    0x8018bf58,%edx
    consputc(buf[i] & 0xff);
801005e3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005e6:	85 d2                	test   %edx,%edx
801005e8:	74 06                	je     801005f0 <consolewrite+0x40>
  asm volatile("cli");
801005ea:	fa                   	cli
    for(;;)
801005eb:	eb fe                	jmp    801005eb <consolewrite+0x3b>
801005ed:	8d 76 00             	lea    0x0(%esi),%esi
801005f0:	e8 0b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005f5:	83 c3 01             	add    $0x1,%ebx
801005f8:	39 fb                	cmp    %edi,%ebx
801005fa:	75 e1                	jne    801005dd <consolewrite+0x2d>
  release(&cons.lock);
801005fc:	83 ec 0c             	sub    $0xc,%esp
801005ff:	68 20 bf 18 80       	push   $0x8018bf20
80100604:	e8 37 3c 00 00       	call   80104240 <release>
  ilock(ip);
80100609:	58                   	pop    %eax
8010060a:	ff 75 08             	push   0x8(%ebp)
8010060d:	e8 8e 11 00 00       	call   801017a0 <ilock>

  return n;
}
80100612:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100615:	89 f0                	mov    %esi,%eax
80100617:	5b                   	pop    %ebx
80100618:	5e                   	pop    %esi
80100619:	5f                   	pop    %edi
8010061a:	5d                   	pop    %ebp
8010061b:	c3                   	ret
8010061c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100620 <printint>:
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	53                   	push   %ebx
80100626:	89 d3                	mov    %edx,%ebx
80100628:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010062b:	85 c0                	test   %eax,%eax
8010062d:	79 05                	jns    80100634 <printint+0x14>
8010062f:	83 e1 01             	and    $0x1,%ecx
80100632:	75 64                	jne    80100698 <printint+0x78>
    x = xx;
80100634:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010063b:	89 c1                	mov    %eax,%ecx
  i = 0;
8010063d:	31 f6                	xor    %esi,%esi
8010063f:	90                   	nop
    buf[i++] = digits[x % base];
80100640:	89 c8                	mov    %ecx,%eax
80100642:	31 d2                	xor    %edx,%edx
80100644:	89 f7                	mov    %esi,%edi
80100646:	f7 f3                	div    %ebx
80100648:	8d 76 01             	lea    0x1(%esi),%esi
8010064b:	0f b6 92 5c 74 10 80 	movzbl -0x7fef8ba4(%edx),%edx
80100652:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100656:	89 ca                	mov    %ecx,%edx
80100658:	89 c1                	mov    %eax,%ecx
8010065a:	39 da                	cmp    %ebx,%edx
8010065c:	73 e2                	jae    80100640 <printint+0x20>
  if(sign)
8010065e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80100661:	85 c9                	test   %ecx,%ecx
80100663:	74 07                	je     8010066c <printint+0x4c>
    buf[i++] = '-';
80100665:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
  while(--i >= 0)
8010066a:	89 f7                	mov    %esi,%edi
8010066c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010066f:	01 df                	add    %ebx,%edi
  if(panicked){
80100671:	8b 15 58 bf 18 80    	mov    0x8018bf58,%edx
    consputc(buf[i]);
80100677:	0f be 07             	movsbl (%edi),%eax
  if(panicked){
8010067a:	85 d2                	test   %edx,%edx
8010067c:	74 0a                	je     80100688 <printint+0x68>
8010067e:	fa                   	cli
    for(;;)
8010067f:	eb fe                	jmp    8010067f <printint+0x5f>
80100681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100688:	e8 73 fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
8010068d:	8d 47 ff             	lea    -0x1(%edi),%eax
80100690:	39 df                	cmp    %ebx,%edi
80100692:	74 11                	je     801006a5 <printint+0x85>
80100694:	89 c7                	mov    %eax,%edi
80100696:	eb d9                	jmp    80100671 <printint+0x51>
    x = -xx;
80100698:	f7 d8                	neg    %eax
  if(sign && (sign = xx < 0))
8010069a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
801006a1:	89 c1                	mov    %eax,%ecx
801006a3:	eb 98                	jmp    8010063d <printint+0x1d>
}
801006a5:	83 c4 2c             	add    $0x2c,%esp
801006a8:	5b                   	pop    %ebx
801006a9:	5e                   	pop    %esi
801006aa:	5f                   	pop    %edi
801006ab:	5d                   	pop    %ebp
801006ac:	c3                   	ret
801006ad:	8d 76 00             	lea    0x0(%esi),%esi

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	8b 3d 54 bf 18 80    	mov    0x8018bf54,%edi
  if (fmt == 0)
801006bf:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801006c2:	85 ff                	test   %edi,%edi
801006c4:	0f 85 06 01 00 00    	jne    801007d0 <cprintf+0x120>
  if (fmt == 0)
801006ca:	85 f6                	test   %esi,%esi
801006cc:	0f 84 b7 01 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d2:	0f b6 06             	movzbl (%esi),%eax
801006d5:	85 c0                	test   %eax,%eax
801006d7:	74 5f                	je     80100738 <cprintf+0x88>
  argp = (uint*)(void*)(&fmt + 1);
801006d9:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006dc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801006df:	31 db                	xor    %ebx,%ebx
801006e1:	89 d7                	mov    %edx,%edi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	75 58                	jne    80100740 <cprintf+0x90>
    c = fmt[++i] & 0xff;
801006e8:	83 c3 01             	add    $0x1,%ebx
801006eb:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
801006ef:	85 c9                	test   %ecx,%ecx
801006f1:	74 3a                	je     8010072d <cprintf+0x7d>
    switch(c){
801006f3:	83 f9 70             	cmp    $0x70,%ecx
801006f6:	0f 84 b4 00 00 00    	je     801007b0 <cprintf+0x100>
801006fc:	7f 72                	jg     80100770 <cprintf+0xc0>
801006fe:	83 f9 25             	cmp    $0x25,%ecx
80100701:	74 4d                	je     80100750 <cprintf+0xa0>
80100703:	83 f9 64             	cmp    $0x64,%ecx
80100706:	75 76                	jne    8010077e <cprintf+0xce>
      printint(*argp++, 10, 1);
80100708:	8d 47 04             	lea    0x4(%edi),%eax
8010070b:	b9 01 00 00 00       	mov    $0x1,%ecx
80100710:	ba 0a 00 00 00       	mov    $0xa,%edx
80100715:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100718:	8b 07                	mov    (%edi),%eax
8010071a:	e8 01 ff ff ff       	call   80100620 <printint>
8010071f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100722:	83 c3 01             	add    $0x1,%ebx
80100725:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	75 b6                	jne    801006e3 <cprintf+0x33>
8010072d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
80100730:	85 ff                	test   %edi,%edi
80100732:	0f 85 bb 00 00 00    	jne    801007f3 <cprintf+0x143>
}
80100738:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010073b:	5b                   	pop    %ebx
8010073c:	5e                   	pop    %esi
8010073d:	5f                   	pop    %edi
8010073e:	5d                   	pop    %ebp
8010073f:	c3                   	ret
  if(panicked){
80100740:	8b 0d 58 bf 18 80    	mov    0x8018bf58,%ecx
80100746:	85 c9                	test   %ecx,%ecx
80100748:	74 19                	je     80100763 <cprintf+0xb3>
8010074a:	fa                   	cli
    for(;;)
8010074b:	eb fe                	jmp    8010074b <cprintf+0x9b>
8010074d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100750:	8b 0d 58 bf 18 80    	mov    0x8018bf58,%ecx
80100756:	85 c9                	test   %ecx,%ecx
80100758:	0f 85 f2 00 00 00    	jne    80100850 <cprintf+0x1a0>
8010075e:	b8 25 00 00 00       	mov    $0x25,%eax
80100763:	e8 98 fc ff ff       	call   80100400 <consputc.part.0>
      break;
80100768:	eb b8                	jmp    80100722 <cprintf+0x72>
8010076a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100770:	83 f9 73             	cmp    $0x73,%ecx
80100773:	0f 84 8f 00 00 00    	je     80100808 <cprintf+0x158>
80100779:	83 f9 78             	cmp    $0x78,%ecx
8010077c:	74 32                	je     801007b0 <cprintf+0x100>
  if(panicked){
8010077e:	8b 15 58 bf 18 80    	mov    0x8018bf58,%edx
80100784:	85 d2                	test   %edx,%edx
80100786:	0f 85 b8 00 00 00    	jne    80100844 <cprintf+0x194>
8010078c:	b8 25 00 00 00       	mov    $0x25,%eax
80100791:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100794:	e8 67 fc ff ff       	call   80100400 <consputc.part.0>
80100799:	a1 58 bf 18 80       	mov    0x8018bf58,%eax
8010079e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801007a1:	85 c0                	test   %eax,%eax
801007a3:	0f 84 cd 00 00 00    	je     80100876 <cprintf+0x1c6>
801007a9:	fa                   	cli
    for(;;)
801007aa:	eb fe                	jmp    801007aa <cprintf+0xfa>
801007ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printint(*argp++, 16, 0);
801007b0:	8d 47 04             	lea    0x4(%edi),%eax
801007b3:	31 c9                	xor    %ecx,%ecx
801007b5:	ba 10 00 00 00       	mov    $0x10,%edx
801007ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007bd:	8b 07                	mov    (%edi),%eax
801007bf:	e8 5c fe ff ff       	call   80100620 <printint>
801007c4:	8b 7d e0             	mov    -0x20(%ebp),%edi
      break;
801007c7:	e9 56 ff ff ff       	jmp    80100722 <cprintf+0x72>
801007cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007d0:	83 ec 0c             	sub    $0xc,%esp
801007d3:	68 20 bf 18 80       	push   $0x8018bf20
801007d8:	e8 c3 3a 00 00       	call   801042a0 <acquire>
  if (fmt == 0)
801007dd:	83 c4 10             	add    $0x10,%esp
801007e0:	85 f6                	test   %esi,%esi
801007e2:	0f 84 a1 00 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007e8:	0f b6 06             	movzbl (%esi),%eax
801007eb:	85 c0                	test   %eax,%eax
801007ed:	0f 85 e6 fe ff ff    	jne    801006d9 <cprintf+0x29>
    release(&cons.lock);
801007f3:	83 ec 0c             	sub    $0xc,%esp
801007f6:	68 20 bf 18 80       	push   $0x8018bf20
801007fb:	e8 40 3a 00 00       	call   80104240 <release>
80100800:	83 c4 10             	add    $0x10,%esp
80100803:	e9 30 ff ff ff       	jmp    80100738 <cprintf+0x88>
      if((s = (char*)*argp++) == 0)
80100808:	8b 17                	mov    (%edi),%edx
8010080a:	8d 47 04             	lea    0x4(%edi),%eax
8010080d:	85 d2                	test   %edx,%edx
8010080f:	74 27                	je     80100838 <cprintf+0x188>
      for(; *s; s++)
80100811:	0f b6 0a             	movzbl (%edx),%ecx
      if((s = (char*)*argp++) == 0)
80100814:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
80100816:	84 c9                	test   %cl,%cl
80100818:	74 68                	je     80100882 <cprintf+0x1d2>
8010081a:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010081d:	89 fb                	mov    %edi,%ebx
8010081f:	89 f7                	mov    %esi,%edi
80100821:	89 c6                	mov    %eax,%esi
80100823:	0f be c1             	movsbl %cl,%eax
  if(panicked){
80100826:	8b 15 58 bf 18 80    	mov    0x8018bf58,%edx
8010082c:	85 d2                	test   %edx,%edx
8010082e:	74 28                	je     80100858 <cprintf+0x1a8>
80100830:	fa                   	cli
    for(;;)
80100831:	eb fe                	jmp    80100831 <cprintf+0x181>
80100833:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100838:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
8010083d:	bf b8 6f 10 80       	mov    $0x80106fb8,%edi
80100842:	eb d6                	jmp    8010081a <cprintf+0x16a>
80100844:	fa                   	cli
    for(;;)
80100845:	eb fe                	jmp    80100845 <cprintf+0x195>
80100847:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010084e:	00 
8010084f:	90                   	nop
80100850:	fa                   	cli
80100851:	eb fe                	jmp    80100851 <cprintf+0x1a1>
80100853:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100858:	e8 a3 fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
8010085d:	0f be 43 01          	movsbl 0x1(%ebx),%eax
80100861:	83 c3 01             	add    $0x1,%ebx
80100864:	84 c0                	test   %al,%al
80100866:	75 be                	jne    80100826 <cprintf+0x176>
      if((s = (char*)*argp++) == 0)
80100868:	89 f0                	mov    %esi,%eax
8010086a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010086d:	89 fe                	mov    %edi,%esi
8010086f:	89 c7                	mov    %eax,%edi
80100871:	e9 ac fe ff ff       	jmp    80100722 <cprintf+0x72>
80100876:	89 c8                	mov    %ecx,%eax
80100878:	e8 83 fb ff ff       	call   80100400 <consputc.part.0>
      break;
8010087d:	e9 a0 fe ff ff       	jmp    80100722 <cprintf+0x72>
      if((s = (char*)*argp++) == 0)
80100882:	89 c7                	mov    %eax,%edi
80100884:	e9 99 fe ff ff       	jmp    80100722 <cprintf+0x72>
    panic("null fmt");
80100889:	83 ec 0c             	sub    $0xc,%esp
8010088c:	68 bf 6f 10 80       	push   $0x80106fbf
80100891:	e8 ea fa ff ff       	call   80100380 <panic>
80100896:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010089d:	00 
8010089e:	66 90                	xchg   %ax,%ax

801008a0 <consoleintr>:
{
801008a0:	55                   	push   %ebp
801008a1:	89 e5                	mov    %esp,%ebp
801008a3:	57                   	push   %edi
  int c, doprocdump = 0;
801008a4:	31 ff                	xor    %edi,%edi
{
801008a6:	56                   	push   %esi
801008a7:	53                   	push   %ebx
801008a8:	83 ec 18             	sub    $0x18,%esp
801008ab:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
801008ae:	68 20 bf 18 80       	push   $0x8018bf20
801008b3:	e8 e8 39 00 00       	call   801042a0 <acquire>
  while((c = getc()) >= 0){
801008b8:	83 c4 10             	add    $0x10,%esp
801008bb:	ff d6                	call   *%esi
801008bd:	89 c3                	mov    %eax,%ebx
801008bf:	85 c0                	test   %eax,%eax
801008c1:	78 22                	js     801008e5 <consoleintr+0x45>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 47                	je     8010090f <consoleintr+0x6f>
801008c8:	7f 76                	jg     80100940 <consoleintr+0xa0>
801008ca:	83 fb 08             	cmp    $0x8,%ebx
801008cd:	74 76                	je     80100945 <consoleintr+0xa5>
801008cf:	83 fb 10             	cmp    $0x10,%ebx
801008d2:	0f 85 f8 00 00 00    	jne    801009d0 <consoleintr+0x130>
  while((c = getc()) >= 0){
801008d8:	ff d6                	call   *%esi
    switch(c){
801008da:	bf 01 00 00 00       	mov    $0x1,%edi
  while((c = getc()) >= 0){
801008df:	89 c3                	mov    %eax,%ebx
801008e1:	85 c0                	test   %eax,%eax
801008e3:	79 de                	jns    801008c3 <consoleintr+0x23>
  release(&cons.lock);
801008e5:	83 ec 0c             	sub    $0xc,%esp
801008e8:	68 20 bf 18 80       	push   $0x8018bf20
801008ed:	e8 4e 39 00 00       	call   80104240 <release>
  if(doprocdump) {
801008f2:	83 c4 10             	add    $0x10,%esp
801008f5:	85 ff                	test   %edi,%edi
801008f7:	0f 85 4b 01 00 00    	jne    80100a48 <consoleintr+0x1a8>
}
801008fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100900:	5b                   	pop    %ebx
80100901:	5e                   	pop    %esi
80100902:	5f                   	pop    %edi
80100903:	5d                   	pop    %ebp
80100904:	c3                   	ret
80100905:	b8 00 01 00 00       	mov    $0x100,%eax
8010090a:	e8 f1 fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
8010090f:	a1 08 bf 18 80       	mov    0x8018bf08,%eax
80100914:	3b 05 04 bf 18 80    	cmp    0x8018bf04,%eax
8010091a:	74 9f                	je     801008bb <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010091c:	83 e8 01             	sub    $0x1,%eax
8010091f:	89 c2                	mov    %eax,%edx
80100921:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100924:	80 ba 80 be 18 80 0a 	cmpb   $0xa,-0x7fe74180(%edx)
8010092b:	74 8e                	je     801008bb <consoleintr+0x1b>
  if(panicked){
8010092d:	8b 15 58 bf 18 80    	mov    0x8018bf58,%edx
        input.e--;
80100933:	a3 08 bf 18 80       	mov    %eax,0x8018bf08
  if(panicked){
80100938:	85 d2                	test   %edx,%edx
8010093a:	74 c9                	je     80100905 <consoleintr+0x65>
8010093c:	fa                   	cli
    for(;;)
8010093d:	eb fe                	jmp    8010093d <consoleintr+0x9d>
8010093f:	90                   	nop
    switch(c){
80100940:	83 fb 7f             	cmp    $0x7f,%ebx
80100943:	75 2b                	jne    80100970 <consoleintr+0xd0>
      if(input.e != input.w){
80100945:	a1 08 bf 18 80       	mov    0x8018bf08,%eax
8010094a:	3b 05 04 bf 18 80    	cmp    0x8018bf04,%eax
80100950:	0f 84 65 ff ff ff    	je     801008bb <consoleintr+0x1b>
        input.e--;
80100956:	83 e8 01             	sub    $0x1,%eax
80100959:	a3 08 bf 18 80       	mov    %eax,0x8018bf08
  if(panicked){
8010095e:	a1 58 bf 18 80       	mov    0x8018bf58,%eax
80100963:	85 c0                	test   %eax,%eax
80100965:	0f 84 ce 00 00 00    	je     80100a39 <consoleintr+0x199>
8010096b:	fa                   	cli
    for(;;)
8010096c:	eb fe                	jmp    8010096c <consoleintr+0xcc>
8010096e:	66 90                	xchg   %ax,%ax
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100970:	a1 08 bf 18 80       	mov    0x8018bf08,%eax
80100975:	89 c2                	mov    %eax,%edx
80100977:	2b 15 00 bf 18 80    	sub    0x8018bf00,%edx
8010097d:	83 fa 7f             	cmp    $0x7f,%edx
80100980:	0f 87 35 ff ff ff    	ja     801008bb <consoleintr+0x1b>
  if(panicked){
80100986:	8b 0d 58 bf 18 80    	mov    0x8018bf58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
8010098c:	8d 50 01             	lea    0x1(%eax),%edx
8010098f:	83 e0 7f             	and    $0x7f,%eax
80100992:	89 15 08 bf 18 80    	mov    %edx,0x8018bf08
80100998:	88 98 80 be 18 80    	mov    %bl,-0x7fe74180(%eax)
  if(panicked){
8010099e:	85 c9                	test   %ecx,%ecx
801009a0:	0f 85 ae 00 00 00    	jne    80100a54 <consoleintr+0x1b4>
801009a6:	89 d8                	mov    %ebx,%eax
801009a8:	e8 53 fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009ad:	83 fb 0a             	cmp    $0xa,%ebx
801009b0:	74 68                	je     80100a1a <consoleintr+0x17a>
801009b2:	83 fb 04             	cmp    $0x4,%ebx
801009b5:	74 63                	je     80100a1a <consoleintr+0x17a>
801009b7:	a1 00 bf 18 80       	mov    0x8018bf00,%eax
801009bc:	83 e8 80             	sub    $0xffffff80,%eax
801009bf:	39 05 08 bf 18 80    	cmp    %eax,0x8018bf08
801009c5:	0f 85 f0 fe ff ff    	jne    801008bb <consoleintr+0x1b>
801009cb:	eb 52                	jmp    80100a1f <consoleintr+0x17f>
801009cd:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009d0:	85 db                	test   %ebx,%ebx
801009d2:	0f 84 e3 fe ff ff    	je     801008bb <consoleintr+0x1b>
801009d8:	a1 08 bf 18 80       	mov    0x8018bf08,%eax
801009dd:	89 c2                	mov    %eax,%edx
801009df:	2b 15 00 bf 18 80    	sub    0x8018bf00,%edx
801009e5:	83 fa 7f             	cmp    $0x7f,%edx
801009e8:	0f 87 cd fe ff ff    	ja     801008bb <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
801009ee:	8d 50 01             	lea    0x1(%eax),%edx
  if(panicked){
801009f1:	8b 0d 58 bf 18 80    	mov    0x8018bf58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
801009f7:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801009fa:	83 fb 0d             	cmp    $0xd,%ebx
801009fd:	75 93                	jne    80100992 <consoleintr+0xf2>
        input.buf[input.e++ % INPUT_BUF] = c;
801009ff:	89 15 08 bf 18 80    	mov    %edx,0x8018bf08
80100a05:	c6 80 80 be 18 80 0a 	movb   $0xa,-0x7fe74180(%eax)
  if(panicked){
80100a0c:	85 c9                	test   %ecx,%ecx
80100a0e:	75 44                	jne    80100a54 <consoleintr+0x1b4>
80100a10:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a15:	e8 e6 f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a1a:	a1 08 bf 18 80       	mov    0x8018bf08,%eax
          wakeup(&input.r);
80100a1f:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a22:	a3 04 bf 18 80       	mov    %eax,0x8018bf04
          wakeup(&input.r);
80100a27:	68 00 bf 18 80       	push   $0x8018bf00
80100a2c:	e8 af 33 00 00       	call   80103de0 <wakeup>
80100a31:	83 c4 10             	add    $0x10,%esp
80100a34:	e9 82 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
80100a39:	b8 00 01 00 00       	mov    $0x100,%eax
80100a3e:	e8 bd f9 ff ff       	call   80100400 <consputc.part.0>
80100a43:	e9 73 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
}
80100a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a4b:	5b                   	pop    %ebx
80100a4c:	5e                   	pop    %esi
80100a4d:	5f                   	pop    %edi
80100a4e:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a4f:	e9 6c 34 00 00       	jmp    80103ec0 <procdump>
80100a54:	fa                   	cli
    for(;;)
80100a55:	eb fe                	jmp    80100a55 <consoleintr+0x1b5>
80100a57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100a5e:	00 
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 c8 6f 10 80       	push   $0x80106fc8
80100a6b:	68 20 bf 18 80       	push   $0x8018bf20
80100a70:	e8 3b 36 00 00       	call   801040b0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c c9 18 80 b0 	movl   $0x801005b0,0x8018c90c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 c9 18 80 80 	movl   $0x80100280,0x8018c908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 bf 18 80 01 	movl   $0x1,0x8018bf54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 c2 16 00 00       	call   80102160 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave
80100aa2:	c3                   	ret
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 9f 2b 00 00       	call   80103660 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 74 1f 00 00       	call   80102a40 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 a9 15 00 00       	call   80102080 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 30 03 00 00    	je     80100e12 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c7                	mov    %eax,%edi
80100ae7:	50                   	push   %eax
80100ae8:	e8 b3 0c 00 00       	call   801017a0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	57                   	push   %edi
80100af9:	e8 b2 0f 00 00       	call   80101ab0 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	0f 85 01 01 00 00    	jne    80100c0b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b0a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b11:	45 4c 46 
80100b14:	0f 85 f1 00 00 00    	jne    80100c0b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b1a:	e8 01 60 00 00       	call   80106b20 <setupkvm>
80100b1f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b25:	85 c0                	test   %eax,%eax
80100b27:	0f 84 de 00 00 00    	je     80100c0b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b2d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b34:	00 
80100b35:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b3b:	0f 84 a1 02 00 00    	je     80100de2 <exec+0x332>
  sz = 0;
80100b41:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b48:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b4b:	31 db                	xor    %ebx,%ebx
80100b4d:	e9 8c 00 00 00       	jmp    80100bde <exec+0x12e>
80100b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100b58:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b5f:	75 6c                	jne    80100bcd <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80100b61:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b67:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b6d:	0f 82 87 00 00 00    	jb     80100bfa <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b73:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b79:	72 7f                	jb     80100bfa <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b7b:	83 ec 04             	sub    $0x4,%esp
80100b7e:	50                   	push   %eax
80100b7f:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b85:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100b8b:	e8 c0 5d 00 00       	call   80106950 <allocuvm>
80100b90:	83 c4 10             	add    $0x10,%esp
80100b93:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b99:	85 c0                	test   %eax,%eax
80100b9b:	74 5d                	je     80100bfa <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b9d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ba3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100ba8:	75 50                	jne    80100bfa <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100baa:	83 ec 0c             	sub    $0xc,%esp
80100bad:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bb3:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bb9:	57                   	push   %edi
80100bba:	50                   	push   %eax
80100bbb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bc1:	e8 ba 5c 00 00       	call   80106880 <loaduvm>
80100bc6:	83 c4 20             	add    $0x20,%esp
80100bc9:	85 c0                	test   %eax,%eax
80100bcb:	78 2d                	js     80100bfa <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bcd:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bd4:	83 c3 01             	add    $0x1,%ebx
80100bd7:	83 c6 20             	add    $0x20,%esi
80100bda:	39 d8                	cmp    %ebx,%eax
80100bdc:	7e 52                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bde:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100be4:	6a 20                	push   $0x20
80100be6:	56                   	push   %esi
80100be7:	50                   	push   %eax
80100be8:	57                   	push   %edi
80100be9:	e8 c2 0e 00 00       	call   80101ab0 <readi>
80100bee:	83 c4 10             	add    $0x10,%esp
80100bf1:	83 f8 20             	cmp    $0x20,%eax
80100bf4:	0f 84 5e ff ff ff    	je     80100b58 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100bfa:	83 ec 0c             	sub    $0xc,%esp
80100bfd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c03:	e8 98 5e 00 00       	call   80106aa0 <freevm>
  if(ip){
80100c08:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c0b:	83 ec 0c             	sub    $0xc,%esp
80100c0e:	57                   	push   %edi
80100c0f:	e8 1c 0e 00 00       	call   80101a30 <iunlockput>
    end_op();
80100c14:	e8 97 1e 00 00       	call   80102ab0 <end_op>
80100c19:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c24:	5b                   	pop    %ebx
80100c25:	5e                   	pop    %esi
80100c26:	5f                   	pop    %edi
80100c27:	5d                   	pop    %ebp
80100c28:	c3                   	ret
80100c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100c30:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c36:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100c3c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	57                   	push   %edi
80100c4c:	e8 df 0d 00 00       	call   80101a30 <iunlockput>
  end_op();
80100c51:	e8 5a 1e 00 00       	call   80102ab0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	53                   	push   %ebx
80100c5a:	56                   	push   %esi
80100c5b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c61:	56                   	push   %esi
80100c62:	e8 e9 5c 00 00       	call   80106950 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c7                	mov    %eax,%edi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 86 00 00 00    	je     80100cfa <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
80100c7d:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 38 5f 00 00       	call   80106bc0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8b 10                	mov    (%eax),%edx
80100c90:	85 d2                	test   %edx,%edx
80100c92:	0f 84 56 01 00 00    	je     80100dee <exec+0x33e>
80100c98:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100c9e:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100ca1:	eb 23                	jmp    80100cc6 <exec+0x216>
80100ca3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100ca8:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100cab:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100cb2:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100cb8:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100cbb:	85 d2                	test   %edx,%edx
80100cbd:	74 51                	je     80100d10 <exec+0x260>
    if(argc >= MAXARG)
80100cbf:	83 f8 20             	cmp    $0x20,%eax
80100cc2:	74 36                	je     80100cfa <exec+0x24a>
80100cc4:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cc6:	83 ec 0c             	sub    $0xc,%esp
80100cc9:	52                   	push   %edx
80100cca:	e8 c1 38 00 00       	call   80104590 <strlen>
80100ccf:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cd1:	58                   	pop    %eax
80100cd2:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cd5:	83 eb 01             	sub    $0x1,%ebx
80100cd8:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cdb:	e8 b0 38 00 00       	call   80104590 <strlen>
80100ce0:	83 c0 01             	add    $0x1,%eax
80100ce3:	50                   	push   %eax
80100ce4:	ff 34 b7             	push   (%edi,%esi,4)
80100ce7:	53                   	push   %ebx
80100ce8:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100cee:	e8 9d 60 00 00       	call   80106d90 <copyout>
80100cf3:	83 c4 20             	add    $0x20,%esp
80100cf6:	85 c0                	test   %eax,%eax
80100cf8:	79 ae                	jns    80100ca8 <exec+0x1f8>
    freevm(pgdir);
80100cfa:	83 ec 0c             	sub    $0xc,%esp
80100cfd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d03:	e8 98 5d 00 00       	call   80106aa0 <freevm>
80100d08:	83 c4 10             	add    $0x10,%esp
80100d0b:	e9 0c ff ff ff       	jmp    80100c1c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d10:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100d17:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d1d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d23:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100d26:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100d29:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100d30:	00 00 00 00 
  ustack[1] = argc;
80100d34:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100d3a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d41:	ff ff ff 
  ustack[1] = argc;
80100d44:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d4a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100d4c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d4e:	29 d0                	sub    %edx,%eax
80100d50:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d56:	56                   	push   %esi
80100d57:	51                   	push   %ecx
80100d58:	53                   	push   %ebx
80100d59:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d5f:	e8 2c 60 00 00       	call   80106d90 <copyout>
80100d64:	83 c4 10             	add    $0x10,%esp
80100d67:	85 c0                	test   %eax,%eax
80100d69:	78 8f                	js     80100cfa <exec+0x24a>
  for(last=s=path; *s; s++)
80100d6b:	8b 45 08             	mov    0x8(%ebp),%eax
80100d6e:	8b 55 08             	mov    0x8(%ebp),%edx
80100d71:	0f b6 00             	movzbl (%eax),%eax
80100d74:	84 c0                	test   %al,%al
80100d76:	74 17                	je     80100d8f <exec+0x2df>
80100d78:	89 d1                	mov    %edx,%ecx
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	83 ec 04             	sub    $0x4,%esp
80100d92:	6a 10                	push   $0x10
80100d94:	52                   	push   %edx
80100d95:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100d9b:	8d 46 6c             	lea    0x6c(%esi),%eax
80100d9e:	50                   	push   %eax
80100d9f:	e8 ac 37 00 00       	call   80104550 <safestrcpy>
  curproc->pgdir = pgdir;
80100da4:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100daa:	89 f0                	mov    %esi,%eax
80100dac:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80100daf:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80100db1:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db4:	89 c1                	mov    %eax,%ecx
80100db6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbc:	8b 40 18             	mov    0x18(%eax),%eax
80100dbf:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc2:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc5:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dc8:	89 0c 24             	mov    %ecx,(%esp)
80100dcb:	e8 20 59 00 00       	call   801066f0 <switchuvm>
  freevm(oldpgdir);
80100dd0:	89 34 24             	mov    %esi,(%esp)
80100dd3:	e8 c8 5c 00 00       	call   80106aa0 <freevm>
  return 0;
80100dd8:	83 c4 10             	add    $0x10,%esp
80100ddb:	31 c0                	xor    %eax,%eax
80100ddd:	e9 3f fe ff ff       	jmp    80100c21 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100de2:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100de7:	31 f6                	xor    %esi,%esi
80100de9:	e9 5a fe ff ff       	jmp    80100c48 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100dee:	be 10 00 00 00       	mov    $0x10,%esi
80100df3:	ba 04 00 00 00       	mov    $0x4,%edx
80100df8:	b8 03 00 00 00       	mov    $0x3,%eax
80100dfd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e04:	00 00 00 
80100e07:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e0d:	e9 17 ff ff ff       	jmp    80100d29 <exec+0x279>
    end_op();
80100e12:	e8 99 1c 00 00       	call   80102ab0 <end_op>
    cprintf("exec: fail\n");
80100e17:	83 ec 0c             	sub    $0xc,%esp
80100e1a:	68 d0 6f 10 80       	push   $0x80106fd0
80100e1f:	e8 8c f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e24:	83 c4 10             	add    $0x10,%esp
80100e27:	e9 f0 fd ff ff       	jmp    80100c1c <exec+0x16c>
80100e2c:	66 90                	xchg   %ax,%ax
80100e2e:	66 90                	xchg   %ax,%ax

80100e30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e36:	68 dc 6f 10 80       	push   $0x80106fdc
80100e3b:	68 60 bf 18 80       	push   $0x8018bf60
80100e40:	e8 6b 32 00 00       	call   801040b0 <initlock>
}
80100e45:	83 c4 10             	add    $0x10,%esp
80100e48:	c9                   	leave
80100e49:	c3                   	ret
80100e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e50:	55                   	push   %ebp
80100e51:	89 e5                	mov    %esp,%ebp
80100e53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e54:	bb 94 bf 18 80       	mov    $0x8018bf94,%ebx
{
80100e59:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e5c:	68 60 bf 18 80       	push   $0x8018bf60
80100e61:	e8 3a 34 00 00       	call   801042a0 <acquire>
80100e66:	83 c4 10             	add    $0x10,%esp
80100e69:	eb 10                	jmp    80100e7b <filealloc+0x2b>
80100e6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e70:	83 c3 18             	add    $0x18,%ebx
80100e73:	81 fb f4 c8 18 80    	cmp    $0x8018c8f4,%ebx
80100e79:	74 25                	je     80100ea0 <filealloc+0x50>
    if(f->ref == 0){
80100e7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e7e:	85 c0                	test   %eax,%eax
80100e80:	75 ee                	jne    80100e70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e82:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e85:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e8c:	68 60 bf 18 80       	push   $0x8018bf60
80100e91:	e8 aa 33 00 00       	call   80104240 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e96:	89 d8                	mov    %ebx,%eax
      return f;
80100e98:	83 c4 10             	add    $0x10,%esp
}
80100e9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e9e:	c9                   	leave
80100e9f:	c3                   	ret
  release(&ftable.lock);
80100ea0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ea3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ea5:	68 60 bf 18 80       	push   $0x8018bf60
80100eaa:	e8 91 33 00 00       	call   80104240 <release>
}
80100eaf:	89 d8                	mov    %ebx,%eax
  return 0;
80100eb1:	83 c4 10             	add    $0x10,%esp
}
80100eb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eb7:	c9                   	leave
80100eb8:	c3                   	ret
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	53                   	push   %ebx
80100ec4:	83 ec 10             	sub    $0x10,%esp
80100ec7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eca:	68 60 bf 18 80       	push   $0x8018bf60
80100ecf:	e8 cc 33 00 00       	call   801042a0 <acquire>
  if(f->ref < 1)
80100ed4:	8b 43 04             	mov    0x4(%ebx),%eax
80100ed7:	83 c4 10             	add    $0x10,%esp
80100eda:	85 c0                	test   %eax,%eax
80100edc:	7e 1a                	jle    80100ef8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ede:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ee1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ee4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ee7:	68 60 bf 18 80       	push   $0x8018bf60
80100eec:	e8 4f 33 00 00       	call   80104240 <release>
  return f;
}
80100ef1:	89 d8                	mov    %ebx,%eax
80100ef3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ef6:	c9                   	leave
80100ef7:	c3                   	ret
    panic("filedup");
80100ef8:	83 ec 0c             	sub    $0xc,%esp
80100efb:	68 e3 6f 10 80       	push   $0x80106fe3
80100f00:	e8 7b f4 ff ff       	call   80100380 <panic>
80100f05:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f0c:	00 
80100f0d:	8d 76 00             	lea    0x0(%esi),%esi

80100f10 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	57                   	push   %edi
80100f14:	56                   	push   %esi
80100f15:	53                   	push   %ebx
80100f16:	83 ec 28             	sub    $0x28,%esp
80100f19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f1c:	68 60 bf 18 80       	push   $0x8018bf60
80100f21:	e8 7a 33 00 00       	call   801042a0 <acquire>
  if(f->ref < 1)
80100f26:	8b 53 04             	mov    0x4(%ebx),%edx
80100f29:	83 c4 10             	add    $0x10,%esp
80100f2c:	85 d2                	test   %edx,%edx
80100f2e:	0f 8e a5 00 00 00    	jle    80100fd9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f34:	83 ea 01             	sub    $0x1,%edx
80100f37:	89 53 04             	mov    %edx,0x4(%ebx)
80100f3a:	75 44                	jne    80100f80 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f3c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f40:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f43:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f45:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f4b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f4e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f51:	8b 43 10             	mov    0x10(%ebx),%eax
80100f54:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f57:	68 60 bf 18 80       	push   $0x8018bf60
80100f5c:	e8 df 32 00 00       	call   80104240 <release>

  if(ff.type == FD_PIPE)
80100f61:	83 c4 10             	add    $0x10,%esp
80100f64:	83 ff 01             	cmp    $0x1,%edi
80100f67:	74 57                	je     80100fc0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f69:	83 ff 02             	cmp    $0x2,%edi
80100f6c:	74 2a                	je     80100f98 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f71:	5b                   	pop    %ebx
80100f72:	5e                   	pop    %esi
80100f73:	5f                   	pop    %edi
80100f74:	5d                   	pop    %ebp
80100f75:	c3                   	ret
80100f76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f7d:	00 
80100f7e:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80100f80:	c7 45 08 60 bf 18 80 	movl   $0x8018bf60,0x8(%ebp)
}
80100f87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8a:	5b                   	pop    %ebx
80100f8b:	5e                   	pop    %esi
80100f8c:	5f                   	pop    %edi
80100f8d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f8e:	e9 ad 32 00 00       	jmp    80104240 <release>
80100f93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80100f98:	e8 a3 1a 00 00       	call   80102a40 <begin_op>
    iput(ff.ip);
80100f9d:	83 ec 0c             	sub    $0xc,%esp
80100fa0:	ff 75 e0             	push   -0x20(%ebp)
80100fa3:	e8 28 09 00 00       	call   801018d0 <iput>
    end_op();
80100fa8:	83 c4 10             	add    $0x10,%esp
}
80100fab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fae:	5b                   	pop    %ebx
80100faf:	5e                   	pop    %esi
80100fb0:	5f                   	pop    %edi
80100fb1:	5d                   	pop    %ebp
    end_op();
80100fb2:	e9 f9 1a 00 00       	jmp    80102ab0 <end_op>
80100fb7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fbe:	00 
80100fbf:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100fc0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fc4:	83 ec 08             	sub    $0x8,%esp
80100fc7:	53                   	push   %ebx
80100fc8:	56                   	push   %esi
80100fc9:	e8 32 22 00 00       	call   80103200 <pipeclose>
80100fce:	83 c4 10             	add    $0x10,%esp
}
80100fd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fd4:	5b                   	pop    %ebx
80100fd5:	5e                   	pop    %esi
80100fd6:	5f                   	pop    %edi
80100fd7:	5d                   	pop    %ebp
80100fd8:	c3                   	ret
    panic("fileclose");
80100fd9:	83 ec 0c             	sub    $0xc,%esp
80100fdc:	68 eb 6f 10 80       	push   $0x80106feb
80100fe1:	e8 9a f3 ff ff       	call   80100380 <panic>
80100fe6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fed:	00 
80100fee:	66 90                	xchg   %ax,%ax

80100ff0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	53                   	push   %ebx
80100ff4:	83 ec 04             	sub    $0x4,%esp
80100ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100ffa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100ffd:	75 31                	jne    80101030 <filestat+0x40>
    ilock(f->ip);
80100fff:	83 ec 0c             	sub    $0xc,%esp
80101002:	ff 73 10             	push   0x10(%ebx)
80101005:	e8 96 07 00 00       	call   801017a0 <ilock>
    stati(f->ip, st);
8010100a:	58                   	pop    %eax
8010100b:	5a                   	pop    %edx
8010100c:	ff 75 0c             	push   0xc(%ebp)
8010100f:	ff 73 10             	push   0x10(%ebx)
80101012:	e8 69 0a 00 00       	call   80101a80 <stati>
    iunlock(f->ip);
80101017:	59                   	pop    %ecx
80101018:	ff 73 10             	push   0x10(%ebx)
8010101b:	e8 60 08 00 00       	call   80101880 <iunlock>
    return 0;
  }
  return -1;
}
80101020:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101023:	83 c4 10             	add    $0x10,%esp
80101026:	31 c0                	xor    %eax,%eax
}
80101028:	c9                   	leave
80101029:	c3                   	ret
8010102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101030:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101033:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101038:	c9                   	leave
80101039:	c3                   	ret
8010103a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101040 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	57                   	push   %edi
80101044:	56                   	push   %esi
80101045:	53                   	push   %ebx
80101046:	83 ec 0c             	sub    $0xc,%esp
80101049:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010104c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010104f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101052:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101056:	74 60                	je     801010b8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101058:	8b 03                	mov    (%ebx),%eax
8010105a:	83 f8 01             	cmp    $0x1,%eax
8010105d:	74 41                	je     801010a0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010105f:	83 f8 02             	cmp    $0x2,%eax
80101062:	75 5b                	jne    801010bf <fileread+0x7f>
    ilock(f->ip);
80101064:	83 ec 0c             	sub    $0xc,%esp
80101067:	ff 73 10             	push   0x10(%ebx)
8010106a:	e8 31 07 00 00       	call   801017a0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010106f:	57                   	push   %edi
80101070:	ff 73 14             	push   0x14(%ebx)
80101073:	56                   	push   %esi
80101074:	ff 73 10             	push   0x10(%ebx)
80101077:	e8 34 0a 00 00       	call   80101ab0 <readi>
8010107c:	83 c4 20             	add    $0x20,%esp
8010107f:	89 c6                	mov    %eax,%esi
80101081:	85 c0                	test   %eax,%eax
80101083:	7e 03                	jle    80101088 <fileread+0x48>
      f->off += r;
80101085:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101088:	83 ec 0c             	sub    $0xc,%esp
8010108b:	ff 73 10             	push   0x10(%ebx)
8010108e:	e8 ed 07 00 00       	call   80101880 <iunlock>
    return r;
80101093:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101096:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101099:	89 f0                	mov    %esi,%eax
8010109b:	5b                   	pop    %ebx
8010109c:	5e                   	pop    %esi
8010109d:	5f                   	pop    %edi
8010109e:	5d                   	pop    %ebp
8010109f:	c3                   	ret
    return piperead(f->pipe, addr, n);
801010a0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010a3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a9:	5b                   	pop    %ebx
801010aa:	5e                   	pop    %esi
801010ab:	5f                   	pop    %edi
801010ac:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010ad:	e9 0e 23 00 00       	jmp    801033c0 <piperead>
801010b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010bd:	eb d7                	jmp    80101096 <fileread+0x56>
  panic("fileread");
801010bf:	83 ec 0c             	sub    $0xc,%esp
801010c2:	68 f5 6f 10 80       	push   $0x80106ff5
801010c7:	e8 b4 f2 ff ff       	call   80100380 <panic>
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010d0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010d0:	55                   	push   %ebp
801010d1:	89 e5                	mov    %esp,%ebp
801010d3:	57                   	push   %edi
801010d4:	56                   	push   %esi
801010d5:	53                   	push   %ebx
801010d6:	83 ec 1c             	sub    $0x1c,%esp
801010d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010df:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010e2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010e5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010ec:	0f 84 bb 00 00 00    	je     801011ad <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
801010f2:	8b 03                	mov    (%ebx),%eax
801010f4:	83 f8 01             	cmp    $0x1,%eax
801010f7:	0f 84 bf 00 00 00    	je     801011bc <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010fd:	83 f8 02             	cmp    $0x2,%eax
80101100:	0f 85 c8 00 00 00    	jne    801011ce <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101109:	31 f6                	xor    %esi,%esi
    while(i < n){
8010110b:	85 c0                	test   %eax,%eax
8010110d:	7f 30                	jg     8010113f <filewrite+0x6f>
8010110f:	e9 94 00 00 00       	jmp    801011a8 <filewrite+0xd8>
80101114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101118:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010111b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010111e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101121:	ff 73 10             	push   0x10(%ebx)
80101124:	e8 57 07 00 00       	call   80101880 <iunlock>
      end_op();
80101129:	e8 82 19 00 00       	call   80102ab0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010112e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101131:	83 c4 10             	add    $0x10,%esp
80101134:	39 c7                	cmp    %eax,%edi
80101136:	75 5c                	jne    80101194 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101138:	01 fe                	add    %edi,%esi
    while(i < n){
8010113a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010113d:	7e 69                	jle    801011a8 <filewrite+0xd8>
      int n1 = n - i;
8010113f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80101142:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101147:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101149:	39 c7                	cmp    %eax,%edi
8010114b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010114e:	e8 ed 18 00 00       	call   80102a40 <begin_op>
      ilock(f->ip);
80101153:	83 ec 0c             	sub    $0xc,%esp
80101156:	ff 73 10             	push   0x10(%ebx)
80101159:	e8 42 06 00 00       	call   801017a0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010115e:	57                   	push   %edi
8010115f:	ff 73 14             	push   0x14(%ebx)
80101162:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101165:	01 f0                	add    %esi,%eax
80101167:	50                   	push   %eax
80101168:	ff 73 10             	push   0x10(%ebx)
8010116b:	e8 40 0a 00 00       	call   80101bb0 <writei>
80101170:	83 c4 20             	add    $0x20,%esp
80101173:	85 c0                	test   %eax,%eax
80101175:	7f a1                	jg     80101118 <filewrite+0x48>
80101177:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010117a:	83 ec 0c             	sub    $0xc,%esp
8010117d:	ff 73 10             	push   0x10(%ebx)
80101180:	e8 fb 06 00 00       	call   80101880 <iunlock>
      end_op();
80101185:	e8 26 19 00 00       	call   80102ab0 <end_op>
      if(r < 0)
8010118a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010118d:	83 c4 10             	add    $0x10,%esp
80101190:	85 c0                	test   %eax,%eax
80101192:	75 14                	jne    801011a8 <filewrite+0xd8>
        panic("short filewrite");
80101194:	83 ec 0c             	sub    $0xc,%esp
80101197:	68 fe 6f 10 80       	push   $0x80106ffe
8010119c:	e8 df f1 ff ff       	call   80100380 <panic>
801011a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801011a8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011ab:	74 05                	je     801011b2 <filewrite+0xe2>
801011ad:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
801011b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b5:	89 f0                	mov    %esi,%eax
801011b7:	5b                   	pop    %ebx
801011b8:	5e                   	pop    %esi
801011b9:	5f                   	pop    %edi
801011ba:	5d                   	pop    %ebp
801011bb:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
801011bc:	8b 43 0c             	mov    0xc(%ebx),%eax
801011bf:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011c5:	5b                   	pop    %ebx
801011c6:	5e                   	pop    %esi
801011c7:	5f                   	pop    %edi
801011c8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011c9:	e9 d2 20 00 00       	jmp    801032a0 <pipewrite>
  panic("filewrite");
801011ce:	83 ec 0c             	sub    $0xc,%esp
801011d1:	68 04 70 10 80       	push   $0x80107004
801011d6:	e8 a5 f1 ff ff       	call   80100380 <panic>
801011db:	66 90                	xchg   %ax,%ax
801011dd:	66 90                	xchg   %ax,%ax
801011df:	90                   	nop

801011e0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801011e0:	55                   	push   %ebp
801011e1:	89 e5                	mov    %esp,%ebp
801011e3:	57                   	push   %edi
801011e4:	56                   	push   %esi
801011e5:	53                   	push   %ebx
801011e6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011e9:	8b 0d b4 e5 18 80    	mov    0x8018e5b4,%ecx
{
801011ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011f2:	85 c9                	test   %ecx,%ecx
801011f4:	0f 84 8c 00 00 00    	je     80101286 <balloc+0xa6>
801011fa:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
801011fc:	89 f8                	mov    %edi,%eax
801011fe:	83 ec 08             	sub    $0x8,%esp
80101201:	89 fe                	mov    %edi,%esi
80101203:	c1 f8 0c             	sar    $0xc,%eax
80101206:	03 05 cc e5 18 80    	add    0x8018e5cc,%eax
8010120c:	50                   	push   %eax
8010120d:	ff 75 dc             	push   -0x24(%ebp)
80101210:	e8 bb ee ff ff       	call   801000d0 <bread>
80101215:	83 c4 10             	add    $0x10,%esp
80101218:	89 7d d8             	mov    %edi,-0x28(%ebp)
8010121b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010121e:	a1 b4 e5 18 80       	mov    0x8018e5b4,%eax
80101223:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101226:	31 c0                	xor    %eax,%eax
80101228:	eb 32                	jmp    8010125c <balloc+0x7c>
8010122a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101230:	89 c1                	mov    %eax,%ecx
80101232:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101237:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010123a:	83 e1 07             	and    $0x7,%ecx
8010123d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010123f:	89 c1                	mov    %eax,%ecx
80101241:	c1 f9 03             	sar    $0x3,%ecx
80101244:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101249:	89 fa                	mov    %edi,%edx
8010124b:	85 df                	test   %ebx,%edi
8010124d:	74 49                	je     80101298 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010124f:	83 c0 01             	add    $0x1,%eax
80101252:	83 c6 01             	add    $0x1,%esi
80101255:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010125a:	74 07                	je     80101263 <balloc+0x83>
8010125c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010125f:	39 d6                	cmp    %edx,%esi
80101261:	72 cd                	jb     80101230 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101263:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101266:	83 ec 0c             	sub    $0xc,%esp
80101269:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010126c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
80101272:	e8 79 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101277:	83 c4 10             	add    $0x10,%esp
8010127a:	3b 3d b4 e5 18 80    	cmp    0x8018e5b4,%edi
80101280:	0f 82 76 ff ff ff    	jb     801011fc <balloc+0x1c>
  }
  panic("balloc: out of blocks");
80101286:	83 ec 0c             	sub    $0xc,%esp
80101289:	68 0e 70 10 80       	push   $0x8010700e
8010128e:	e8 ed f0 ff ff       	call   80100380 <panic>
80101293:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101298:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
8010129b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
8010129e:	09 da                	or     %ebx,%edx
801012a0:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012a4:	57                   	push   %edi
801012a5:	e8 76 19 00 00       	call   80102c20 <log_write>
        brelse(bp);
801012aa:	89 3c 24             	mov    %edi,(%esp)
801012ad:	e8 3e ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012b2:	58                   	pop    %eax
801012b3:	5a                   	pop    %edx
801012b4:	56                   	push   %esi
801012b5:	ff 75 dc             	push   -0x24(%ebp)
801012b8:	e8 13 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801012bd:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801012c0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012c2:	8d 40 5c             	lea    0x5c(%eax),%eax
801012c5:	68 00 02 00 00       	push   $0x200
801012ca:	6a 00                	push   $0x0
801012cc:	50                   	push   %eax
801012cd:	e8 ce 30 00 00       	call   801043a0 <memset>
  log_write(bp);
801012d2:	89 1c 24             	mov    %ebx,(%esp)
801012d5:	e8 46 19 00 00       	call   80102c20 <log_write>
  brelse(bp);
801012da:	89 1c 24             	mov    %ebx,(%esp)
801012dd:	e8 0e ef ff ff       	call   801001f0 <brelse>
}
801012e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012e5:	89 f0                	mov    %esi,%eax
801012e7:	5b                   	pop    %ebx
801012e8:	5e                   	pop    %esi
801012e9:	5f                   	pop    %edi
801012ea:	5d                   	pop    %ebp
801012eb:	c3                   	ret
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012f0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012f4:	31 ff                	xor    %edi,%edi
{
801012f6:	56                   	push   %esi
801012f7:	89 c6                	mov    %eax,%esi
801012f9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012fa:	bb 94 c9 18 80       	mov    $0x8018c994,%ebx
{
801012ff:	83 ec 28             	sub    $0x28,%esp
80101302:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101305:	68 60 c9 18 80       	push   $0x8018c960
8010130a:	e8 91 2f 00 00       	call   801042a0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010130f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101312:	83 c4 10             	add    $0x10,%esp
80101315:	eb 1b                	jmp    80101332 <iget+0x42>
80101317:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010131e:	00 
8010131f:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101320:	39 33                	cmp    %esi,(%ebx)
80101322:	74 6c                	je     80101390 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101324:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010132a:	81 fb b4 e5 18 80    	cmp    $0x8018e5b4,%ebx
80101330:	74 26                	je     80101358 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101332:	8b 43 08             	mov    0x8(%ebx),%eax
80101335:	85 c0                	test   %eax,%eax
80101337:	7f e7                	jg     80101320 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101339:	85 ff                	test   %edi,%edi
8010133b:	75 e7                	jne    80101324 <iget+0x34>
8010133d:	85 c0                	test   %eax,%eax
8010133f:	75 76                	jne    801013b7 <iget+0xc7>
      empty = ip;
80101341:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101343:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101349:	81 fb b4 e5 18 80    	cmp    $0x8018e5b4,%ebx
8010134f:	75 e1                	jne    80101332 <iget+0x42>
80101351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101358:	85 ff                	test   %edi,%edi
8010135a:	74 79                	je     801013d5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010135c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010135f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101361:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101364:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
8010136b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
80101372:	68 60 c9 18 80       	push   $0x8018c960
80101377:	e8 c4 2e 00 00       	call   80104240 <release>

  return ip;
8010137c:	83 c4 10             	add    $0x10,%esp
}
8010137f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101382:	89 f8                	mov    %edi,%eax
80101384:	5b                   	pop    %ebx
80101385:	5e                   	pop    %esi
80101386:	5f                   	pop    %edi
80101387:	5d                   	pop    %ebp
80101388:	c3                   	ret
80101389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101390:	39 53 04             	cmp    %edx,0x4(%ebx)
80101393:	75 8f                	jne    80101324 <iget+0x34>
      ip->ref++;
80101395:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
80101398:	83 ec 0c             	sub    $0xc,%esp
      return ip;
8010139b:	89 df                	mov    %ebx,%edi
      ip->ref++;
8010139d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801013a0:	68 60 c9 18 80       	push   $0x8018c960
801013a5:	e8 96 2e 00 00       	call   80104240 <release>
      return ip;
801013aa:	83 c4 10             	add    $0x10,%esp
}
801013ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013b0:	89 f8                	mov    %edi,%eax
801013b2:	5b                   	pop    %ebx
801013b3:	5e                   	pop    %esi
801013b4:	5f                   	pop    %edi
801013b5:	5d                   	pop    %ebp
801013b6:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013b7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013bd:	81 fb b4 e5 18 80    	cmp    $0x8018e5b4,%ebx
801013c3:	74 10                	je     801013d5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013c5:	8b 43 08             	mov    0x8(%ebx),%eax
801013c8:	85 c0                	test   %eax,%eax
801013ca:	0f 8f 50 ff ff ff    	jg     80101320 <iget+0x30>
801013d0:	e9 68 ff ff ff       	jmp    8010133d <iget+0x4d>
    panic("iget: no inodes");
801013d5:	83 ec 0c             	sub    $0xc,%esp
801013d8:	68 24 70 10 80       	push   $0x80107024
801013dd:	e8 9e ef ff ff       	call   80100380 <panic>
801013e2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801013e9:	00 
801013ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801013f0 <bfree>:
{
801013f0:	55                   	push   %ebp
801013f1:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
801013f3:	89 d0                	mov    %edx,%eax
801013f5:	c1 e8 0c             	shr    $0xc,%eax
{
801013f8:	89 e5                	mov    %esp,%ebp
801013fa:	56                   	push   %esi
801013fb:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
801013fc:	03 05 cc e5 18 80    	add    0x8018e5cc,%eax
{
80101402:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101404:	83 ec 08             	sub    $0x8,%esp
80101407:	50                   	push   %eax
80101408:	51                   	push   %ecx
80101409:	e8 c2 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010140e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101410:	c1 fb 03             	sar    $0x3,%ebx
80101413:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101416:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101418:	83 e1 07             	and    $0x7,%ecx
8010141b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101420:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101426:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101428:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010142d:	85 c1                	test   %eax,%ecx
8010142f:	74 23                	je     80101454 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80101431:	f7 d0                	not    %eax
  log_write(bp);
80101433:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101436:	21 c8                	and    %ecx,%eax
80101438:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010143c:	56                   	push   %esi
8010143d:	e8 de 17 00 00       	call   80102c20 <log_write>
  brelse(bp);
80101442:	89 34 24             	mov    %esi,(%esp)
80101445:	e8 a6 ed ff ff       	call   801001f0 <brelse>
}
8010144a:	83 c4 10             	add    $0x10,%esp
8010144d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101450:	5b                   	pop    %ebx
80101451:	5e                   	pop    %esi
80101452:	5d                   	pop    %ebp
80101453:	c3                   	ret
    panic("freeing free block");
80101454:	83 ec 0c             	sub    $0xc,%esp
80101457:	68 34 70 10 80       	push   $0x80107034
8010145c:	e8 1f ef ff ff       	call   80100380 <panic>
80101461:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101468:	00 
80101469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101470 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	57                   	push   %edi
80101474:	56                   	push   %esi
80101475:	89 c6                	mov    %eax,%esi
80101477:	53                   	push   %ebx
80101478:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010147b:	83 fa 0b             	cmp    $0xb,%edx
8010147e:	0f 86 8c 00 00 00    	jbe    80101510 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101484:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101487:	83 fb 7f             	cmp    $0x7f,%ebx
8010148a:	0f 87 a2 00 00 00    	ja     80101532 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101490:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101496:	85 c0                	test   %eax,%eax
80101498:	74 5e                	je     801014f8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010149a:	83 ec 08             	sub    $0x8,%esp
8010149d:	50                   	push   %eax
8010149e:	ff 36                	push   (%esi)
801014a0:	e8 2b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014a5:	83 c4 10             	add    $0x10,%esp
801014a8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801014ac:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801014ae:	8b 3b                	mov    (%ebx),%edi
801014b0:	85 ff                	test   %edi,%edi
801014b2:	74 1c                	je     801014d0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014b4:	83 ec 0c             	sub    $0xc,%esp
801014b7:	52                   	push   %edx
801014b8:	e8 33 ed ff ff       	call   801001f0 <brelse>
801014bd:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014c3:	89 f8                	mov    %edi,%eax
801014c5:	5b                   	pop    %ebx
801014c6:	5e                   	pop    %esi
801014c7:	5f                   	pop    %edi
801014c8:	5d                   	pop    %ebp
801014c9:	c3                   	ret
801014ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014d3:	8b 06                	mov    (%esi),%eax
801014d5:	e8 06 fd ff ff       	call   801011e0 <balloc>
      log_write(bp);
801014da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014dd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014e0:	89 03                	mov    %eax,(%ebx)
801014e2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014e4:	52                   	push   %edx
801014e5:	e8 36 17 00 00       	call   80102c20 <log_write>
801014ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014ed:	83 c4 10             	add    $0x10,%esp
801014f0:	eb c2                	jmp    801014b4 <bmap+0x44>
801014f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014f8:	8b 06                	mov    (%esi),%eax
801014fa:	e8 e1 fc ff ff       	call   801011e0 <balloc>
801014ff:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101505:	eb 93                	jmp    8010149a <bmap+0x2a>
80101507:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010150e:	00 
8010150f:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80101510:	8d 5a 14             	lea    0x14(%edx),%ebx
80101513:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101517:	85 ff                	test   %edi,%edi
80101519:	75 a5                	jne    801014c0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010151b:	8b 00                	mov    (%eax),%eax
8010151d:	e8 be fc ff ff       	call   801011e0 <balloc>
80101522:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101526:	89 c7                	mov    %eax,%edi
}
80101528:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010152b:	5b                   	pop    %ebx
8010152c:	89 f8                	mov    %edi,%eax
8010152e:	5e                   	pop    %esi
8010152f:	5f                   	pop    %edi
80101530:	5d                   	pop    %ebp
80101531:	c3                   	ret
  panic("bmap: out of range");
80101532:	83 ec 0c             	sub    $0xc,%esp
80101535:	68 47 70 10 80       	push   $0x80107047
8010153a:	e8 41 ee ff ff       	call   80100380 <panic>
8010153f:	90                   	nop

80101540 <readsb>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	56                   	push   %esi
80101544:	53                   	push   %ebx
80101545:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101548:	83 ec 08             	sub    $0x8,%esp
8010154b:	6a 01                	push   $0x1
8010154d:	ff 75 08             	push   0x8(%ebp)
80101550:	e8 7b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101555:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101558:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010155a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010155d:	6a 1c                	push   $0x1c
8010155f:	50                   	push   %eax
80101560:	56                   	push   %esi
80101561:	e8 ca 2e 00 00       	call   80104430 <memmove>
  brelse(bp);
80101566:	83 c4 10             	add    $0x10,%esp
80101569:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010156c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010156f:	5b                   	pop    %ebx
80101570:	5e                   	pop    %esi
80101571:	5d                   	pop    %ebp
  brelse(bp);
80101572:	e9 79 ec ff ff       	jmp    801001f0 <brelse>
80101577:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010157e:	00 
8010157f:	90                   	nop

80101580 <iinit>:
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	53                   	push   %ebx
80101584:	bb a0 c9 18 80       	mov    $0x8018c9a0,%ebx
80101589:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010158c:	68 5a 70 10 80       	push   $0x8010705a
80101591:	68 60 c9 18 80       	push   $0x8018c960
80101596:	e8 15 2b 00 00       	call   801040b0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010159b:	83 c4 10             	add    $0x10,%esp
8010159e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015a0:	83 ec 08             	sub    $0x8,%esp
801015a3:	68 61 70 10 80       	push   $0x80107061
801015a8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015af:	e8 cc 29 00 00       	call   80103f80 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015b4:	83 c4 10             	add    $0x10,%esp
801015b7:	81 fb c0 e5 18 80    	cmp    $0x8018e5c0,%ebx
801015bd:	75 e1                	jne    801015a0 <iinit+0x20>
  bp = bread(dev, 1);
801015bf:	83 ec 08             	sub    $0x8,%esp
801015c2:	6a 01                	push   $0x1
801015c4:	ff 75 08             	push   0x8(%ebp)
801015c7:	e8 04 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015cc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015cf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015d1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015d4:	6a 1c                	push   $0x1c
801015d6:	50                   	push   %eax
801015d7:	68 b4 e5 18 80       	push   $0x8018e5b4
801015dc:	e8 4f 2e 00 00       	call   80104430 <memmove>
  brelse(bp);
801015e1:	89 1c 24             	mov    %ebx,(%esp)
801015e4:	e8 07 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015e9:	ff 35 cc e5 18 80    	push   0x8018e5cc
801015ef:	ff 35 c8 e5 18 80    	push   0x8018e5c8
801015f5:	ff 35 c4 e5 18 80    	push   0x8018e5c4
801015fb:	ff 35 c0 e5 18 80    	push   0x8018e5c0
80101601:	ff 35 bc e5 18 80    	push   0x8018e5bc
80101607:	ff 35 b8 e5 18 80    	push   0x8018e5b8
8010160d:	ff 35 b4 e5 18 80    	push   0x8018e5b4
80101613:	68 70 74 10 80       	push   $0x80107470
80101618:	e8 93 f0 ff ff       	call   801006b0 <cprintf>
}
8010161d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101620:	83 c4 30             	add    $0x30,%esp
80101623:	c9                   	leave
80101624:	c3                   	ret
80101625:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010162c:	00 
8010162d:	8d 76 00             	lea    0x0(%esi),%esi

80101630 <ialloc>:
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	57                   	push   %edi
80101634:	56                   	push   %esi
80101635:	53                   	push   %ebx
80101636:	83 ec 1c             	sub    $0x1c,%esp
80101639:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010163c:	83 3d bc e5 18 80 01 	cmpl   $0x1,0x8018e5bc
{
80101643:	8b 75 08             	mov    0x8(%ebp),%esi
80101646:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101649:	0f 86 91 00 00 00    	jbe    801016e0 <ialloc+0xb0>
8010164f:	bf 01 00 00 00       	mov    $0x1,%edi
80101654:	eb 21                	jmp    80101677 <ialloc+0x47>
80101656:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010165d:	00 
8010165e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101660:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101663:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101666:	53                   	push   %ebx
80101667:	e8 84 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010166c:	83 c4 10             	add    $0x10,%esp
8010166f:	3b 3d bc e5 18 80    	cmp    0x8018e5bc,%edi
80101675:	73 69                	jae    801016e0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101677:	89 f8                	mov    %edi,%eax
80101679:	83 ec 08             	sub    $0x8,%esp
8010167c:	c1 e8 03             	shr    $0x3,%eax
8010167f:	03 05 c8 e5 18 80    	add    0x8018e5c8,%eax
80101685:	50                   	push   %eax
80101686:	56                   	push   %esi
80101687:	e8 44 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010168c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010168f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101691:	89 f8                	mov    %edi,%eax
80101693:	83 e0 07             	and    $0x7,%eax
80101696:	c1 e0 06             	shl    $0x6,%eax
80101699:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010169d:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016a1:	75 bd                	jne    80101660 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016a3:	83 ec 04             	sub    $0x4,%esp
801016a6:	6a 40                	push   $0x40
801016a8:	6a 00                	push   $0x0
801016aa:	51                   	push   %ecx
801016ab:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016ae:	e8 ed 2c 00 00       	call   801043a0 <memset>
      dip->type = type;
801016b3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016ba:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016bd:	89 1c 24             	mov    %ebx,(%esp)
801016c0:	e8 5b 15 00 00       	call   80102c20 <log_write>
      brelse(bp);
801016c5:	89 1c 24             	mov    %ebx,(%esp)
801016c8:	e8 23 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016cd:	83 c4 10             	add    $0x10,%esp
}
801016d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016d3:	89 fa                	mov    %edi,%edx
}
801016d5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016d6:	89 f0                	mov    %esi,%eax
}
801016d8:	5e                   	pop    %esi
801016d9:	5f                   	pop    %edi
801016da:	5d                   	pop    %ebp
      return iget(dev, inum);
801016db:	e9 10 fc ff ff       	jmp    801012f0 <iget>
  panic("ialloc: no inodes");
801016e0:	83 ec 0c             	sub    $0xc,%esp
801016e3:	68 67 70 10 80       	push   $0x80107067
801016e8:	e8 93 ec ff ff       	call   80100380 <panic>
801016ed:	8d 76 00             	lea    0x0(%esi),%esi

801016f0 <iupdate>:
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	56                   	push   %esi
801016f4:	53                   	push   %ebx
801016f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016fb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fe:	83 ec 08             	sub    $0x8,%esp
80101701:	c1 e8 03             	shr    $0x3,%eax
80101704:	03 05 c8 e5 18 80    	add    0x8018e5c8,%eax
8010170a:	50                   	push   %eax
8010170b:	ff 73 a4             	push   -0x5c(%ebx)
8010170e:	e8 bd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101713:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101717:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010171a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010171c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010171f:	83 e0 07             	and    $0x7,%eax
80101722:	c1 e0 06             	shl    $0x6,%eax
80101725:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101729:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010172c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101730:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101733:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101737:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010173b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010173f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101743:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101747:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010174a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010174d:	6a 34                	push   $0x34
8010174f:	53                   	push   %ebx
80101750:	50                   	push   %eax
80101751:	e8 da 2c 00 00       	call   80104430 <memmove>
  log_write(bp);
80101756:	89 34 24             	mov    %esi,(%esp)
80101759:	e8 c2 14 00 00       	call   80102c20 <log_write>
  brelse(bp);
8010175e:	83 c4 10             	add    $0x10,%esp
80101761:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101764:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101767:	5b                   	pop    %ebx
80101768:	5e                   	pop    %esi
80101769:	5d                   	pop    %ebp
  brelse(bp);
8010176a:	e9 81 ea ff ff       	jmp    801001f0 <brelse>
8010176f:	90                   	nop

80101770 <idup>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	53                   	push   %ebx
80101774:	83 ec 10             	sub    $0x10,%esp
80101777:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010177a:	68 60 c9 18 80       	push   $0x8018c960
8010177f:	e8 1c 2b 00 00       	call   801042a0 <acquire>
  ip->ref++;
80101784:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101788:	c7 04 24 60 c9 18 80 	movl   $0x8018c960,(%esp)
8010178f:	e8 ac 2a 00 00       	call   80104240 <release>
}
80101794:	89 d8                	mov    %ebx,%eax
80101796:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101799:	c9                   	leave
8010179a:	c3                   	ret
8010179b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801017a0 <ilock>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017a8:	85 db                	test   %ebx,%ebx
801017aa:	0f 84 b7 00 00 00    	je     80101867 <ilock+0xc7>
801017b0:	8b 53 08             	mov    0x8(%ebx),%edx
801017b3:	85 d2                	test   %edx,%edx
801017b5:	0f 8e ac 00 00 00    	jle    80101867 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017bb:	83 ec 0c             	sub    $0xc,%esp
801017be:	8d 43 0c             	lea    0xc(%ebx),%eax
801017c1:	50                   	push   %eax
801017c2:	e8 f9 27 00 00       	call   80103fc0 <acquiresleep>
  if(ip->valid == 0){
801017c7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017ca:	83 c4 10             	add    $0x10,%esp
801017cd:	85 c0                	test   %eax,%eax
801017cf:	74 0f                	je     801017e0 <ilock+0x40>
}
801017d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017d4:	5b                   	pop    %ebx
801017d5:	5e                   	pop    %esi
801017d6:	5d                   	pop    %ebp
801017d7:	c3                   	ret
801017d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801017df:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017e0:	8b 43 04             	mov    0x4(%ebx),%eax
801017e3:	83 ec 08             	sub    $0x8,%esp
801017e6:	c1 e8 03             	shr    $0x3,%eax
801017e9:	03 05 c8 e5 18 80    	add    0x8018e5c8,%eax
801017ef:	50                   	push   %eax
801017f0:	ff 33                	push   (%ebx)
801017f2:	e8 d9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017fa:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017fc:	8b 43 04             	mov    0x4(%ebx),%eax
801017ff:	83 e0 07             	and    $0x7,%eax
80101802:	c1 e0 06             	shl    $0x6,%eax
80101805:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101809:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010180c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010180f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101813:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101817:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010181b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010181f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101823:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101827:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010182b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010182e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101831:	6a 34                	push   $0x34
80101833:	50                   	push   %eax
80101834:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101837:	50                   	push   %eax
80101838:	e8 f3 2b 00 00       	call   80104430 <memmove>
    brelse(bp);
8010183d:	89 34 24             	mov    %esi,(%esp)
80101840:	e8 ab e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101845:	83 c4 10             	add    $0x10,%esp
80101848:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010184d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101854:	0f 85 77 ff ff ff    	jne    801017d1 <ilock+0x31>
      panic("ilock: no type");
8010185a:	83 ec 0c             	sub    $0xc,%esp
8010185d:	68 7f 70 10 80       	push   $0x8010707f
80101862:	e8 19 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101867:	83 ec 0c             	sub    $0xc,%esp
8010186a:	68 79 70 10 80       	push   $0x80107079
8010186f:	e8 0c eb ff ff       	call   80100380 <panic>
80101874:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010187b:	00 
8010187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101880 <iunlock>:
{
80101880:	55                   	push   %ebp
80101881:	89 e5                	mov    %esp,%ebp
80101883:	56                   	push   %esi
80101884:	53                   	push   %ebx
80101885:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101888:	85 db                	test   %ebx,%ebx
8010188a:	74 28                	je     801018b4 <iunlock+0x34>
8010188c:	83 ec 0c             	sub    $0xc,%esp
8010188f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101892:	56                   	push   %esi
80101893:	e8 c8 27 00 00       	call   80104060 <holdingsleep>
80101898:	83 c4 10             	add    $0x10,%esp
8010189b:	85 c0                	test   %eax,%eax
8010189d:	74 15                	je     801018b4 <iunlock+0x34>
8010189f:	8b 43 08             	mov    0x8(%ebx),%eax
801018a2:	85 c0                	test   %eax,%eax
801018a4:	7e 0e                	jle    801018b4 <iunlock+0x34>
  releasesleep(&ip->lock);
801018a6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018ac:	5b                   	pop    %ebx
801018ad:	5e                   	pop    %esi
801018ae:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018af:	e9 6c 27 00 00       	jmp    80104020 <releasesleep>
    panic("iunlock");
801018b4:	83 ec 0c             	sub    $0xc,%esp
801018b7:	68 8e 70 10 80       	push   $0x8010708e
801018bc:	e8 bf ea ff ff       	call   80100380 <panic>
801018c1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018c8:	00 
801018c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801018d0 <iput>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	57                   	push   %edi
801018d4:	56                   	push   %esi
801018d5:	53                   	push   %ebx
801018d6:	83 ec 28             	sub    $0x28,%esp
801018d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018dc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018df:	57                   	push   %edi
801018e0:	e8 db 26 00 00       	call   80103fc0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018e5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018e8:	83 c4 10             	add    $0x10,%esp
801018eb:	85 d2                	test   %edx,%edx
801018ed:	74 07                	je     801018f6 <iput+0x26>
801018ef:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018f4:	74 32                	je     80101928 <iput+0x58>
  releasesleep(&ip->lock);
801018f6:	83 ec 0c             	sub    $0xc,%esp
801018f9:	57                   	push   %edi
801018fa:	e8 21 27 00 00       	call   80104020 <releasesleep>
  acquire(&icache.lock);
801018ff:	c7 04 24 60 c9 18 80 	movl   $0x8018c960,(%esp)
80101906:	e8 95 29 00 00       	call   801042a0 <acquire>
  ip->ref--;
8010190b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010190f:	83 c4 10             	add    $0x10,%esp
80101912:	c7 45 08 60 c9 18 80 	movl   $0x8018c960,0x8(%ebp)
}
80101919:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010191c:	5b                   	pop    %ebx
8010191d:	5e                   	pop    %esi
8010191e:	5f                   	pop    %edi
8010191f:	5d                   	pop    %ebp
  release(&icache.lock);
80101920:	e9 1b 29 00 00       	jmp    80104240 <release>
80101925:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101928:	83 ec 0c             	sub    $0xc,%esp
8010192b:	68 60 c9 18 80       	push   $0x8018c960
80101930:	e8 6b 29 00 00       	call   801042a0 <acquire>
    int r = ip->ref;
80101935:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101938:	c7 04 24 60 c9 18 80 	movl   $0x8018c960,(%esp)
8010193f:	e8 fc 28 00 00       	call   80104240 <release>
    if(r == 1){
80101944:	83 c4 10             	add    $0x10,%esp
80101947:	83 fe 01             	cmp    $0x1,%esi
8010194a:	75 aa                	jne    801018f6 <iput+0x26>
8010194c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101952:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101955:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101958:	89 df                	mov    %ebx,%edi
8010195a:	89 cb                	mov    %ecx,%ebx
8010195c:	eb 09                	jmp    80101967 <iput+0x97>
8010195e:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101960:	83 c6 04             	add    $0x4,%esi
80101963:	39 de                	cmp    %ebx,%esi
80101965:	74 19                	je     80101980 <iput+0xb0>
    if(ip->addrs[i]){
80101967:	8b 16                	mov    (%esi),%edx
80101969:	85 d2                	test   %edx,%edx
8010196b:	74 f3                	je     80101960 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010196d:	8b 07                	mov    (%edi),%eax
8010196f:	e8 7c fa ff ff       	call   801013f0 <bfree>
      ip->addrs[i] = 0;
80101974:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010197a:	eb e4                	jmp    80101960 <iput+0x90>
8010197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101980:	89 fb                	mov    %edi,%ebx
80101982:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101985:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010198b:	85 c0                	test   %eax,%eax
8010198d:	75 2d                	jne    801019bc <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010198f:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101992:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101999:	53                   	push   %ebx
8010199a:	e8 51 fd ff ff       	call   801016f0 <iupdate>
      ip->type = 0;
8010199f:	31 c0                	xor    %eax,%eax
801019a1:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019a5:	89 1c 24             	mov    %ebx,(%esp)
801019a8:	e8 43 fd ff ff       	call   801016f0 <iupdate>
      ip->valid = 0;
801019ad:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019b4:	83 c4 10             	add    $0x10,%esp
801019b7:	e9 3a ff ff ff       	jmp    801018f6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019bc:	83 ec 08             	sub    $0x8,%esp
801019bf:	50                   	push   %eax
801019c0:	ff 33                	push   (%ebx)
801019c2:	e8 09 e7 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801019c7:	83 c4 10             	add    $0x10,%esp
801019ca:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019cd:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801019d6:	8d 70 5c             	lea    0x5c(%eax),%esi
801019d9:	89 cf                	mov    %ecx,%edi
801019db:	eb 0a                	jmp    801019e7 <iput+0x117>
801019dd:	8d 76 00             	lea    0x0(%esi),%esi
801019e0:	83 c6 04             	add    $0x4,%esi
801019e3:	39 fe                	cmp    %edi,%esi
801019e5:	74 0f                	je     801019f6 <iput+0x126>
      if(a[j])
801019e7:	8b 16                	mov    (%esi),%edx
801019e9:	85 d2                	test   %edx,%edx
801019eb:	74 f3                	je     801019e0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019ed:	8b 03                	mov    (%ebx),%eax
801019ef:	e8 fc f9 ff ff       	call   801013f0 <bfree>
801019f4:	eb ea                	jmp    801019e0 <iput+0x110>
    brelse(bp);
801019f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801019f9:	83 ec 0c             	sub    $0xc,%esp
801019fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019ff:	50                   	push   %eax
80101a00:	e8 eb e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a05:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a0b:	8b 03                	mov    (%ebx),%eax
80101a0d:	e8 de f9 ff ff       	call   801013f0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a12:	83 c4 10             	add    $0x10,%esp
80101a15:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a1c:	00 00 00 
80101a1f:	e9 6b ff ff ff       	jmp    8010198f <iput+0xbf>
80101a24:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101a2b:	00 
80101a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a30 <iunlockput>:
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	56                   	push   %esi
80101a34:	53                   	push   %ebx
80101a35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a38:	85 db                	test   %ebx,%ebx
80101a3a:	74 34                	je     80101a70 <iunlockput+0x40>
80101a3c:	83 ec 0c             	sub    $0xc,%esp
80101a3f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a42:	56                   	push   %esi
80101a43:	e8 18 26 00 00       	call   80104060 <holdingsleep>
80101a48:	83 c4 10             	add    $0x10,%esp
80101a4b:	85 c0                	test   %eax,%eax
80101a4d:	74 21                	je     80101a70 <iunlockput+0x40>
80101a4f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a52:	85 c0                	test   %eax,%eax
80101a54:	7e 1a                	jle    80101a70 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a56:	83 ec 0c             	sub    $0xc,%esp
80101a59:	56                   	push   %esi
80101a5a:	e8 c1 25 00 00       	call   80104020 <releasesleep>
  iput(ip);
80101a5f:	83 c4 10             	add    $0x10,%esp
80101a62:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101a65:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a68:	5b                   	pop    %ebx
80101a69:	5e                   	pop    %esi
80101a6a:	5d                   	pop    %ebp
  iput(ip);
80101a6b:	e9 60 fe ff ff       	jmp    801018d0 <iput>
    panic("iunlock");
80101a70:	83 ec 0c             	sub    $0xc,%esp
80101a73:	68 8e 70 10 80       	push   $0x8010708e
80101a78:	e8 03 e9 ff ff       	call   80100380 <panic>
80101a7d:	8d 76 00             	lea    0x0(%esi),%esi

80101a80 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	8b 55 08             	mov    0x8(%ebp),%edx
80101a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a89:	8b 0a                	mov    (%edx),%ecx
80101a8b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a8e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a91:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a94:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a98:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a9b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a9f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101aa3:	8b 52 58             	mov    0x58(%edx),%edx
80101aa6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101aa9:	5d                   	pop    %ebp
80101aaa:	c3                   	ret
80101aab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101ab0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	57                   	push   %edi
80101ab4:	56                   	push   %esi
80101ab5:	53                   	push   %ebx
80101ab6:	83 ec 1c             	sub    $0x1c,%esp
80101ab9:	8b 75 08             	mov    0x8(%ebp),%esi
80101abc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101abf:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ac2:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101ac7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101aca:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101acd:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101ad0:	0f 84 aa 00 00 00    	je     80101b80 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ad6:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101ad9:	8b 56 58             	mov    0x58(%esi),%edx
80101adc:	39 fa                	cmp    %edi,%edx
80101ade:	0f 82 bd 00 00 00    	jb     80101ba1 <readi+0xf1>
80101ae4:	89 f9                	mov    %edi,%ecx
80101ae6:	31 db                	xor    %ebx,%ebx
80101ae8:	01 c1                	add    %eax,%ecx
80101aea:	0f 92 c3             	setb   %bl
80101aed:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101af0:	0f 82 ab 00 00 00    	jb     80101ba1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101af6:	89 d3                	mov    %edx,%ebx
80101af8:	29 fb                	sub    %edi,%ebx
80101afa:	39 ca                	cmp    %ecx,%edx
80101afc:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aff:	85 c0                	test   %eax,%eax
80101b01:	74 73                	je     80101b76 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101b03:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b10:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b13:	89 fa                	mov    %edi,%edx
80101b15:	c1 ea 09             	shr    $0x9,%edx
80101b18:	89 d8                	mov    %ebx,%eax
80101b1a:	e8 51 f9 ff ff       	call   80101470 <bmap>
80101b1f:	83 ec 08             	sub    $0x8,%esp
80101b22:	50                   	push   %eax
80101b23:	ff 33                	push   (%ebx)
80101b25:	e8 a6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b2a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b2d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b32:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b34:	89 f8                	mov    %edi,%eax
80101b36:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b3b:	29 f3                	sub    %esi,%ebx
80101b3d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b3f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b43:	39 d9                	cmp    %ebx,%ecx
80101b45:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b48:	83 c4 0c             	add    $0xc,%esp
80101b4b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b4c:	01 de                	add    %ebx,%esi
80101b4e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101b50:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101b53:	50                   	push   %eax
80101b54:	ff 75 e0             	push   -0x20(%ebp)
80101b57:	e8 d4 28 00 00       	call   80104430 <memmove>
    brelse(bp);
80101b5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b5f:	89 14 24             	mov    %edx,(%esp)
80101b62:	e8 89 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b67:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b6a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b6d:	83 c4 10             	add    $0x10,%esp
80101b70:	39 de                	cmp    %ebx,%esi
80101b72:	72 9c                	jb     80101b10 <readi+0x60>
80101b74:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101b76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b79:	5b                   	pop    %ebx
80101b7a:	5e                   	pop    %esi
80101b7b:	5f                   	pop    %edi
80101b7c:	5d                   	pop    %ebp
80101b7d:	c3                   	ret
80101b7e:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b80:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101b84:	66 83 fa 09          	cmp    $0x9,%dx
80101b88:	77 17                	ja     80101ba1 <readi+0xf1>
80101b8a:	8b 14 d5 00 c9 18 80 	mov    -0x7fe73700(,%edx,8),%edx
80101b91:	85 d2                	test   %edx,%edx
80101b93:	74 0c                	je     80101ba1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b95:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b9b:	5b                   	pop    %ebx
80101b9c:	5e                   	pop    %esi
80101b9d:	5f                   	pop    %edi
80101b9e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b9f:	ff e2                	jmp    *%edx
      return -1;
80101ba1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ba6:	eb ce                	jmp    80101b76 <readi+0xc6>
80101ba8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101baf:	00 

80101bb0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101bbf:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bc2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bc7:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101bca:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101bcd:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101bd0:	0f 84 ba 00 00 00    	je     80101c90 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bd6:	39 78 58             	cmp    %edi,0x58(%eax)
80101bd9:	0f 82 ea 00 00 00    	jb     80101cc9 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bdf:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101be2:	89 f2                	mov    %esi,%edx
80101be4:	01 fa                	add    %edi,%edx
80101be6:	0f 82 dd 00 00 00    	jb     80101cc9 <writei+0x119>
80101bec:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101bf2:	0f 87 d1 00 00 00    	ja     80101cc9 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bf8:	85 f6                	test   %esi,%esi
80101bfa:	0f 84 85 00 00 00    	je     80101c85 <writei+0xd5>
80101c00:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c07:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c10:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101c13:	89 fa                	mov    %edi,%edx
80101c15:	c1 ea 09             	shr    $0x9,%edx
80101c18:	89 f0                	mov    %esi,%eax
80101c1a:	e8 51 f8 ff ff       	call   80101470 <bmap>
80101c1f:	83 ec 08             	sub    $0x8,%esp
80101c22:	50                   	push   %eax
80101c23:	ff 36                	push   (%esi)
80101c25:	e8 a6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c2d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c30:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c35:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c37:	89 f8                	mov    %edi,%eax
80101c39:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c3e:	29 d3                	sub    %edx,%ebx
80101c40:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c42:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c46:	39 d9                	cmp    %ebx,%ecx
80101c48:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c4b:	83 c4 0c             	add    $0xc,%esp
80101c4e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c4f:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101c51:	ff 75 dc             	push   -0x24(%ebp)
80101c54:	50                   	push   %eax
80101c55:	e8 d6 27 00 00       	call   80104430 <memmove>
    log_write(bp);
80101c5a:	89 34 24             	mov    %esi,(%esp)
80101c5d:	e8 be 0f 00 00       	call   80102c20 <log_write>
    brelse(bp);
80101c62:	89 34 24             	mov    %esi,(%esp)
80101c65:	e8 86 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c6a:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c70:	83 c4 10             	add    $0x10,%esp
80101c73:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c76:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c79:	39 d8                	cmp    %ebx,%eax
80101c7b:	72 93                	jb     80101c10 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c7d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c80:	39 78 58             	cmp    %edi,0x58(%eax)
80101c83:	72 33                	jb     80101cb8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c85:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
80101c8f:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c94:	66 83 f8 09          	cmp    $0x9,%ax
80101c98:	77 2f                	ja     80101cc9 <writei+0x119>
80101c9a:	8b 04 c5 04 c9 18 80 	mov    -0x7fe736fc(,%eax,8),%eax
80101ca1:	85 c0                	test   %eax,%eax
80101ca3:	74 24                	je     80101cc9 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80101ca5:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cab:	5b                   	pop    %ebx
80101cac:	5e                   	pop    %esi
80101cad:	5f                   	pop    %edi
80101cae:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101caf:	ff e0                	jmp    *%eax
80101cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101cb8:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cbb:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101cbe:	50                   	push   %eax
80101cbf:	e8 2c fa ff ff       	call   801016f0 <iupdate>
80101cc4:	83 c4 10             	add    $0x10,%esp
80101cc7:	eb bc                	jmp    80101c85 <writei+0xd5>
      return -1;
80101cc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cce:	eb b8                	jmp    80101c88 <writei+0xd8>

80101cd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cd6:	6a 0e                	push   $0xe
80101cd8:	ff 75 0c             	push   0xc(%ebp)
80101cdb:	ff 75 08             	push   0x8(%ebp)
80101cde:	e8 bd 27 00 00       	call   801044a0 <strncmp>
}
80101ce3:	c9                   	leave
80101ce4:	c3                   	ret
80101ce5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101cec:	00 
80101ced:	8d 76 00             	lea    0x0(%esi),%esi

80101cf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cf0:	55                   	push   %ebp
80101cf1:	89 e5                	mov    %esp,%ebp
80101cf3:	57                   	push   %edi
80101cf4:	56                   	push   %esi
80101cf5:	53                   	push   %ebx
80101cf6:	83 ec 1c             	sub    $0x1c,%esp
80101cf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d01:	0f 85 85 00 00 00    	jne    80101d8c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d07:	8b 53 58             	mov    0x58(%ebx),%edx
80101d0a:	31 ff                	xor    %edi,%edi
80101d0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d0f:	85 d2                	test   %edx,%edx
80101d11:	74 3e                	je     80101d51 <dirlookup+0x61>
80101d13:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d18:	6a 10                	push   $0x10
80101d1a:	57                   	push   %edi
80101d1b:	56                   	push   %esi
80101d1c:	53                   	push   %ebx
80101d1d:	e8 8e fd ff ff       	call   80101ab0 <readi>
80101d22:	83 c4 10             	add    $0x10,%esp
80101d25:	83 f8 10             	cmp    $0x10,%eax
80101d28:	75 55                	jne    80101d7f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d2f:	74 18                	je     80101d49 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d31:	83 ec 04             	sub    $0x4,%esp
80101d34:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d37:	6a 0e                	push   $0xe
80101d39:	50                   	push   %eax
80101d3a:	ff 75 0c             	push   0xc(%ebp)
80101d3d:	e8 5e 27 00 00       	call   801044a0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d42:	83 c4 10             	add    $0x10,%esp
80101d45:	85 c0                	test   %eax,%eax
80101d47:	74 17                	je     80101d60 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d49:	83 c7 10             	add    $0x10,%edi
80101d4c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d4f:	72 c7                	jb     80101d18 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d54:	31 c0                	xor    %eax,%eax
}
80101d56:	5b                   	pop    %ebx
80101d57:	5e                   	pop    %esi
80101d58:	5f                   	pop    %edi
80101d59:	5d                   	pop    %ebp
80101d5a:	c3                   	ret
80101d5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80101d60:	8b 45 10             	mov    0x10(%ebp),%eax
80101d63:	85 c0                	test   %eax,%eax
80101d65:	74 05                	je     80101d6c <dirlookup+0x7c>
        *poff = off;
80101d67:	8b 45 10             	mov    0x10(%ebp),%eax
80101d6a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d6c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d70:	8b 03                	mov    (%ebx),%eax
80101d72:	e8 79 f5 ff ff       	call   801012f0 <iget>
}
80101d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d7a:	5b                   	pop    %ebx
80101d7b:	5e                   	pop    %esi
80101d7c:	5f                   	pop    %edi
80101d7d:	5d                   	pop    %ebp
80101d7e:	c3                   	ret
      panic("dirlookup read");
80101d7f:	83 ec 0c             	sub    $0xc,%esp
80101d82:	68 a8 70 10 80       	push   $0x801070a8
80101d87:	e8 f4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d8c:	83 ec 0c             	sub    $0xc,%esp
80101d8f:	68 96 70 10 80       	push   $0x80107096
80101d94:	e8 e7 e5 ff ff       	call   80100380 <panic>
80101d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101da0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101da0:	55                   	push   %ebp
80101da1:	89 e5                	mov    %esp,%ebp
80101da3:	57                   	push   %edi
80101da4:	56                   	push   %esi
80101da5:	53                   	push   %ebx
80101da6:	89 c3                	mov    %eax,%ebx
80101da8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dab:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dae:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101db1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101db4:	0f 84 9e 01 00 00    	je     80101f58 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dba:	e8 a1 18 00 00       	call   80103660 <myproc>
  acquire(&icache.lock);
80101dbf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101dc2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101dc5:	68 60 c9 18 80       	push   $0x8018c960
80101dca:	e8 d1 24 00 00       	call   801042a0 <acquire>
  ip->ref++;
80101dcf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dd3:	c7 04 24 60 c9 18 80 	movl   $0x8018c960,(%esp)
80101dda:	e8 61 24 00 00       	call   80104240 <release>
80101ddf:	83 c4 10             	add    $0x10,%esp
80101de2:	eb 07                	jmp    80101deb <namex+0x4b>
80101de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101de8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101deb:	0f b6 03             	movzbl (%ebx),%eax
80101dee:	3c 2f                	cmp    $0x2f,%al
80101df0:	74 f6                	je     80101de8 <namex+0x48>
  if(*path == 0)
80101df2:	84 c0                	test   %al,%al
80101df4:	0f 84 06 01 00 00    	je     80101f00 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dfa:	0f b6 03             	movzbl (%ebx),%eax
80101dfd:	84 c0                	test   %al,%al
80101dff:	0f 84 10 01 00 00    	je     80101f15 <namex+0x175>
80101e05:	89 df                	mov    %ebx,%edi
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	0f 84 06 01 00 00    	je     80101f15 <namex+0x175>
80101e0f:	90                   	nop
80101e10:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e14:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e17:	3c 2f                	cmp    $0x2f,%al
80101e19:	74 04                	je     80101e1f <namex+0x7f>
80101e1b:	84 c0                	test   %al,%al
80101e1d:	75 f1                	jne    80101e10 <namex+0x70>
  len = path - s;
80101e1f:	89 f8                	mov    %edi,%eax
80101e21:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e23:	83 f8 0d             	cmp    $0xd,%eax
80101e26:	0f 8e ac 00 00 00    	jle    80101ed8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e2c:	83 ec 04             	sub    $0x4,%esp
80101e2f:	6a 0e                	push   $0xe
80101e31:	53                   	push   %ebx
80101e32:	89 fb                	mov    %edi,%ebx
80101e34:	ff 75 e4             	push   -0x1c(%ebp)
80101e37:	e8 f4 25 00 00       	call   80104430 <memmove>
80101e3c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e3f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e42:	75 0c                	jne    80101e50 <namex+0xb0>
80101e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e4b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e4e:	74 f8                	je     80101e48 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e50:	83 ec 0c             	sub    $0xc,%esp
80101e53:	56                   	push   %esi
80101e54:	e8 47 f9 ff ff       	call   801017a0 <ilock>
    if(ip->type != T_DIR){
80101e59:	83 c4 10             	add    $0x10,%esp
80101e5c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e61:	0f 85 b7 00 00 00    	jne    80101f1e <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e67:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 09                	je     80101e77 <namex+0xd7>
80101e6e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e71:	0f 84 f7 00 00 00    	je     80101f6e <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e77:	83 ec 04             	sub    $0x4,%esp
80101e7a:	6a 00                	push   $0x0
80101e7c:	ff 75 e4             	push   -0x1c(%ebp)
80101e7f:	56                   	push   %esi
80101e80:	e8 6b fe ff ff       	call   80101cf0 <dirlookup>
80101e85:	83 c4 10             	add    $0x10,%esp
80101e88:	89 c7                	mov    %eax,%edi
80101e8a:	85 c0                	test   %eax,%eax
80101e8c:	0f 84 8c 00 00 00    	je     80101f1e <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e92:	83 ec 0c             	sub    $0xc,%esp
80101e95:	8d 4e 0c             	lea    0xc(%esi),%ecx
80101e98:	51                   	push   %ecx
80101e99:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101e9c:	e8 bf 21 00 00       	call   80104060 <holdingsleep>
80101ea1:	83 c4 10             	add    $0x10,%esp
80101ea4:	85 c0                	test   %eax,%eax
80101ea6:	0f 84 02 01 00 00    	je     80101fae <namex+0x20e>
80101eac:	8b 56 08             	mov    0x8(%esi),%edx
80101eaf:	85 d2                	test   %edx,%edx
80101eb1:	0f 8e f7 00 00 00    	jle    80101fae <namex+0x20e>
  releasesleep(&ip->lock);
80101eb7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101eba:	83 ec 0c             	sub    $0xc,%esp
80101ebd:	51                   	push   %ecx
80101ebe:	e8 5d 21 00 00       	call   80104020 <releasesleep>
  iput(ip);
80101ec3:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101ec6:	89 fe                	mov    %edi,%esi
  iput(ip);
80101ec8:	e8 03 fa ff ff       	call   801018d0 <iput>
80101ecd:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101ed0:	e9 16 ff ff ff       	jmp    80101deb <namex+0x4b>
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ed8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101edb:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
80101ede:	83 ec 04             	sub    $0x4,%esp
80101ee1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101ee4:	50                   	push   %eax
80101ee5:	53                   	push   %ebx
    name[len] = 0;
80101ee6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ee8:	ff 75 e4             	push   -0x1c(%ebp)
80101eeb:	e8 40 25 00 00       	call   80104430 <memmove>
    name[len] = 0;
80101ef0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101ef3:	83 c4 10             	add    $0x10,%esp
80101ef6:	c6 01 00             	movb   $0x0,(%ecx)
80101ef9:	e9 41 ff ff ff       	jmp    80101e3f <namex+0x9f>
80101efe:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80101f00:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f03:	85 c0                	test   %eax,%eax
80101f05:	0f 85 93 00 00 00    	jne    80101f9e <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f0e:	89 f0                	mov    %esi,%eax
80101f10:	5b                   	pop    %ebx
80101f11:	5e                   	pop    %esi
80101f12:	5f                   	pop    %edi
80101f13:	5d                   	pop    %ebp
80101f14:	c3                   	ret
  while(*path != '/' && *path != 0)
80101f15:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f18:	89 df                	mov    %ebx,%edi
80101f1a:	31 c0                	xor    %eax,%eax
80101f1c:	eb c0                	jmp    80101ede <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f1e:	83 ec 0c             	sub    $0xc,%esp
80101f21:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f24:	53                   	push   %ebx
80101f25:	e8 36 21 00 00       	call   80104060 <holdingsleep>
80101f2a:	83 c4 10             	add    $0x10,%esp
80101f2d:	85 c0                	test   %eax,%eax
80101f2f:	74 7d                	je     80101fae <namex+0x20e>
80101f31:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f34:	85 c9                	test   %ecx,%ecx
80101f36:	7e 76                	jle    80101fae <namex+0x20e>
  releasesleep(&ip->lock);
80101f38:	83 ec 0c             	sub    $0xc,%esp
80101f3b:	53                   	push   %ebx
80101f3c:	e8 df 20 00 00       	call   80104020 <releasesleep>
  iput(ip);
80101f41:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f44:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f46:	e8 85 f9 ff ff       	call   801018d0 <iput>
      return 0;
80101f4b:	83 c4 10             	add    $0x10,%esp
}
80101f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f51:	89 f0                	mov    %esi,%eax
80101f53:	5b                   	pop    %ebx
80101f54:	5e                   	pop    %esi
80101f55:	5f                   	pop    %edi
80101f56:	5d                   	pop    %ebp
80101f57:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80101f58:	ba 01 00 00 00       	mov    $0x1,%edx
80101f5d:	b8 01 00 00 00       	mov    $0x1,%eax
80101f62:	e8 89 f3 ff ff       	call   801012f0 <iget>
80101f67:	89 c6                	mov    %eax,%esi
80101f69:	e9 7d fe ff ff       	jmp    80101deb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f6e:	83 ec 0c             	sub    $0xc,%esp
80101f71:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f74:	53                   	push   %ebx
80101f75:	e8 e6 20 00 00       	call   80104060 <holdingsleep>
80101f7a:	83 c4 10             	add    $0x10,%esp
80101f7d:	85 c0                	test   %eax,%eax
80101f7f:	74 2d                	je     80101fae <namex+0x20e>
80101f81:	8b 7e 08             	mov    0x8(%esi),%edi
80101f84:	85 ff                	test   %edi,%edi
80101f86:	7e 26                	jle    80101fae <namex+0x20e>
  releasesleep(&ip->lock);
80101f88:	83 ec 0c             	sub    $0xc,%esp
80101f8b:	53                   	push   %ebx
80101f8c:	e8 8f 20 00 00       	call   80104020 <releasesleep>
}
80101f91:	83 c4 10             	add    $0x10,%esp
}
80101f94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f97:	89 f0                	mov    %esi,%eax
80101f99:	5b                   	pop    %ebx
80101f9a:	5e                   	pop    %esi
80101f9b:	5f                   	pop    %edi
80101f9c:	5d                   	pop    %ebp
80101f9d:	c3                   	ret
    iput(ip);
80101f9e:	83 ec 0c             	sub    $0xc,%esp
80101fa1:	56                   	push   %esi
      return 0;
80101fa2:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fa4:	e8 27 f9 ff ff       	call   801018d0 <iput>
    return 0;
80101fa9:	83 c4 10             	add    $0x10,%esp
80101fac:	eb a0                	jmp    80101f4e <namex+0x1ae>
    panic("iunlock");
80101fae:	83 ec 0c             	sub    $0xc,%esp
80101fb1:	68 8e 70 10 80       	push   $0x8010708e
80101fb6:	e8 c5 e3 ff ff       	call   80100380 <panic>
80101fbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101fc0 <dirlink>:
{
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	57                   	push   %edi
80101fc4:	56                   	push   %esi
80101fc5:	53                   	push   %ebx
80101fc6:	83 ec 20             	sub    $0x20,%esp
80101fc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fcc:	6a 00                	push   $0x0
80101fce:	ff 75 0c             	push   0xc(%ebp)
80101fd1:	53                   	push   %ebx
80101fd2:	e8 19 fd ff ff       	call   80101cf0 <dirlookup>
80101fd7:	83 c4 10             	add    $0x10,%esp
80101fda:	85 c0                	test   %eax,%eax
80101fdc:	75 67                	jne    80102045 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fde:	8b 7b 58             	mov    0x58(%ebx),%edi
80101fe1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fe4:	85 ff                	test   %edi,%edi
80101fe6:	74 29                	je     80102011 <dirlink+0x51>
80101fe8:	31 ff                	xor    %edi,%edi
80101fea:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fed:	eb 09                	jmp    80101ff8 <dirlink+0x38>
80101fef:	90                   	nop
80101ff0:	83 c7 10             	add    $0x10,%edi
80101ff3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101ff6:	73 19                	jae    80102011 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ff8:	6a 10                	push   $0x10
80101ffa:	57                   	push   %edi
80101ffb:	56                   	push   %esi
80101ffc:	53                   	push   %ebx
80101ffd:	e8 ae fa ff ff       	call   80101ab0 <readi>
80102002:	83 c4 10             	add    $0x10,%esp
80102005:	83 f8 10             	cmp    $0x10,%eax
80102008:	75 4e                	jne    80102058 <dirlink+0x98>
    if(de.inum == 0)
8010200a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010200f:	75 df                	jne    80101ff0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102011:	83 ec 04             	sub    $0x4,%esp
80102014:	8d 45 da             	lea    -0x26(%ebp),%eax
80102017:	6a 0e                	push   $0xe
80102019:	ff 75 0c             	push   0xc(%ebp)
8010201c:	50                   	push   %eax
8010201d:	e8 ce 24 00 00       	call   801044f0 <strncpy>
  de.inum = inum;
80102022:	8b 45 10             	mov    0x10(%ebp),%eax
80102025:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102029:	6a 10                	push   $0x10
8010202b:	57                   	push   %edi
8010202c:	56                   	push   %esi
8010202d:	53                   	push   %ebx
8010202e:	e8 7d fb ff ff       	call   80101bb0 <writei>
80102033:	83 c4 20             	add    $0x20,%esp
80102036:	83 f8 10             	cmp    $0x10,%eax
80102039:	75 2a                	jne    80102065 <dirlink+0xa5>
  return 0;
8010203b:	31 c0                	xor    %eax,%eax
}
8010203d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102040:	5b                   	pop    %ebx
80102041:	5e                   	pop    %esi
80102042:	5f                   	pop    %edi
80102043:	5d                   	pop    %ebp
80102044:	c3                   	ret
    iput(ip);
80102045:	83 ec 0c             	sub    $0xc,%esp
80102048:	50                   	push   %eax
80102049:	e8 82 f8 ff ff       	call   801018d0 <iput>
    return -1;
8010204e:	83 c4 10             	add    $0x10,%esp
80102051:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102056:	eb e5                	jmp    8010203d <dirlink+0x7d>
      panic("dirlink read");
80102058:	83 ec 0c             	sub    $0xc,%esp
8010205b:	68 b7 70 10 80       	push   $0x801070b7
80102060:	e8 1b e3 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	68 ab 72 10 80       	push   $0x801072ab
8010206d:	e8 0e e3 ff ff       	call   80100380 <panic>
80102072:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102079:	00 
8010207a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102080 <namei>:

struct inode*
namei(char *path)
{
80102080:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102081:	31 d2                	xor    %edx,%edx
{
80102083:	89 e5                	mov    %esp,%ebp
80102085:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102088:	8b 45 08             	mov    0x8(%ebp),%eax
8010208b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010208e:	e8 0d fd ff ff       	call   80101da0 <namex>
}
80102093:	c9                   	leave
80102094:	c3                   	ret
80102095:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010209c:	00 
8010209d:	8d 76 00             	lea    0x0(%esi),%esi

801020a0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020a0:	55                   	push   %ebp
  return namex(path, 1, name);
801020a1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020a6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ae:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020af:	e9 ec fc ff ff       	jmp    80101da0 <namex>
801020b4:	66 90                	xchg   %ax,%ax
801020b6:	66 90                	xchg   %ax,%ax
801020b8:	66 90                	xchg   %ax,%ax
801020ba:	66 90                	xchg   %ax,%ax
801020bc:	66 90                	xchg   %ax,%ax
801020be:	66 90                	xchg   %ax,%ax

801020c0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801020c0:	55                   	push   %ebp
801020c1:	89 e5                	mov    %esp,%ebp
801020c3:	56                   	push   %esi
801020c4:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801020c5:	c7 05 d0 e5 18 80 00 	movl   $0xfec00000,0x8018e5d0
801020cc:	00 c0 fe 
  ioapic->reg = reg;
801020cf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801020d6:	00 00 00 
  return ioapic->data;
801020d9:	8b 15 d0 e5 18 80    	mov    0x8018e5d0,%edx
801020df:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801020e2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801020e8:	8b 1d d0 e5 18 80    	mov    0x8018e5d0,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801020ee:	0f b6 15 20 e7 18 80 	movzbl 0x8018e720,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801020f5:	c1 ee 10             	shr    $0x10,%esi
801020f8:	89 f0                	mov    %esi,%eax
801020fa:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801020fd:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102100:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102103:	39 c2                	cmp    %eax,%edx
80102105:	74 16                	je     8010211d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102107:	83 ec 0c             	sub    $0xc,%esp
8010210a:	68 c4 74 10 80       	push   $0x801074c4
8010210f:	e8 9c e5 ff ff       	call   801006b0 <cprintf>
  ioapic->reg = reg;
80102114:	8b 1d d0 e5 18 80    	mov    0x8018e5d0,%ebx
8010211a:	83 c4 10             	add    $0x10,%esp
{
8010211d:	ba 10 00 00 00       	mov    $0x10,%edx
80102122:	31 c0                	xor    %eax,%eax
80102124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80102128:	89 13                	mov    %edx,(%ebx)
8010212a:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
8010212d:	8b 1d d0 e5 18 80    	mov    0x8018e5d0,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102133:	83 c0 01             	add    $0x1,%eax
80102136:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
8010213c:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
8010213f:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
80102142:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102145:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102147:	8b 1d d0 e5 18 80    	mov    0x8018e5d0,%ebx
8010214d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
80102154:	39 c6                	cmp    %eax,%esi
80102156:	7d d0                	jge    80102128 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102158:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010215b:	5b                   	pop    %ebx
8010215c:	5e                   	pop    %esi
8010215d:	5d                   	pop    %ebp
8010215e:	c3                   	ret
8010215f:	90                   	nop

80102160 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102160:	55                   	push   %ebp
  ioapic->reg = reg;
80102161:	8b 0d d0 e5 18 80    	mov    0x8018e5d0,%ecx
{
80102167:	89 e5                	mov    %esp,%ebp
80102169:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010216c:	8d 50 20             	lea    0x20(%eax),%edx
8010216f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102173:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102175:	8b 0d d0 e5 18 80    	mov    0x8018e5d0,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010217b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010217e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102181:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102184:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102186:	a1 d0 e5 18 80       	mov    0x8018e5d0,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010218b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010218e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102191:	5d                   	pop    %ebp
80102192:	c3                   	ret
80102193:	66 90                	xchg   %ax,%ax
80102195:	66 90                	xchg   %ax,%ax
80102197:	66 90                	xchg   %ax,%ax
80102199:	66 90                	xchg   %ax,%ax
8010219b:	66 90                	xchg   %ax,%ax
8010219d:	66 90                	xchg   %ax,%ax
8010219f:	90                   	nop

801021a0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801021a0:	55                   	push   %ebp
801021a1:	89 e5                	mov    %esp,%ebp
801021a3:	53                   	push   %ebx
801021a4:	83 ec 04             	sub    $0x4,%esp
801021a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801021aa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801021b0:	75 76                	jne    80102228 <kfree+0x88>
801021b2:	81 fb 70 24 19 80    	cmp    $0x80192470,%ebx
801021b8:	72 6e                	jb     80102228 <kfree+0x88>
801021ba:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801021c0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801021c5:	77 61                	ja     80102228 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801021c7:	83 ec 04             	sub    $0x4,%esp
801021ca:	68 00 10 00 00       	push   $0x1000
801021cf:	6a 01                	push   $0x1
801021d1:	53                   	push   %ebx
801021d2:	e8 c9 21 00 00       	call   801043a0 <memset>

  if(kmem.use_lock)
801021d7:	8b 15 14 e6 18 80    	mov    0x8018e614,%edx
801021dd:	83 c4 10             	add    $0x10,%esp
801021e0:	85 d2                	test   %edx,%edx
801021e2:	75 1c                	jne    80102200 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801021e4:	a1 18 e6 18 80       	mov    0x8018e618,%eax
801021e9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801021eb:	a1 14 e6 18 80       	mov    0x8018e614,%eax
  kmem.freelist = r;
801021f0:	89 1d 18 e6 18 80    	mov    %ebx,0x8018e618
  if(kmem.use_lock)
801021f6:	85 c0                	test   %eax,%eax
801021f8:	75 1e                	jne    80102218 <kfree+0x78>
    release(&kmem.lock);
}
801021fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021fd:	c9                   	leave
801021fe:	c3                   	ret
801021ff:	90                   	nop
    acquire(&kmem.lock);
80102200:	83 ec 0c             	sub    $0xc,%esp
80102203:	68 e0 e5 18 80       	push   $0x8018e5e0
80102208:	e8 93 20 00 00       	call   801042a0 <acquire>
8010220d:	83 c4 10             	add    $0x10,%esp
80102210:	eb d2                	jmp    801021e4 <kfree+0x44>
80102212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102218:	c7 45 08 e0 e5 18 80 	movl   $0x8018e5e0,0x8(%ebp)
}
8010221f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102222:	c9                   	leave
    release(&kmem.lock);
80102223:	e9 18 20 00 00       	jmp    80104240 <release>
    panic("kfree");
80102228:	83 ec 0c             	sub    $0xc,%esp
8010222b:	68 c4 70 10 80       	push   $0x801070c4
80102230:	e8 4b e1 ff ff       	call   80100380 <panic>
80102235:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010223c:	00 
8010223d:	8d 76 00             	lea    0x0(%esi),%esi

80102240 <freerange>:
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	56                   	push   %esi
80102244:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102245:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102248:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010224b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102251:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102257:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010225d:	39 de                	cmp    %ebx,%esi
8010225f:	72 23                	jb     80102284 <freerange+0x44>
80102261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102268:	83 ec 0c             	sub    $0xc,%esp
8010226b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102271:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102277:	50                   	push   %eax
80102278:	e8 23 ff ff ff       	call   801021a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010227d:	83 c4 10             	add    $0x10,%esp
80102280:	39 de                	cmp    %ebx,%esi
80102282:	73 e4                	jae    80102268 <freerange+0x28>
}
80102284:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102287:	5b                   	pop    %ebx
80102288:	5e                   	pop    %esi
80102289:	5d                   	pop    %ebp
8010228a:	c3                   	ret
8010228b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102290 <kinit2>:
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	56                   	push   %esi
80102294:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102295:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102298:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010229b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801022a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801022a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801022ad:	39 de                	cmp    %ebx,%esi
801022af:	72 23                	jb     801022d4 <kinit2+0x44>
801022b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801022b8:	83 ec 0c             	sub    $0xc,%esp
801022bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801022c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801022c7:	50                   	push   %eax
801022c8:	e8 d3 fe ff ff       	call   801021a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801022cd:	83 c4 10             	add    $0x10,%esp
801022d0:	39 de                	cmp    %ebx,%esi
801022d2:	73 e4                	jae    801022b8 <kinit2+0x28>
  kmem.use_lock = 1;
801022d4:	c7 05 14 e6 18 80 01 	movl   $0x1,0x8018e614
801022db:	00 00 00 
}
801022de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022e1:	5b                   	pop    %ebx
801022e2:	5e                   	pop    %esi
801022e3:	5d                   	pop    %ebp
801022e4:	c3                   	ret
801022e5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022ec:	00 
801022ed:	8d 76 00             	lea    0x0(%esi),%esi

801022f0 <kinit1>:
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	56                   	push   %esi
801022f4:	53                   	push   %ebx
801022f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801022f8:	83 ec 08             	sub    $0x8,%esp
801022fb:	68 ca 70 10 80       	push   $0x801070ca
80102300:	68 e0 e5 18 80       	push   $0x8018e5e0
80102305:	e8 a6 1d 00 00       	call   801040b0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010230a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010230d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102310:	c7 05 14 e6 18 80 00 	movl   $0x0,0x8018e614
80102317:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010231a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102320:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102326:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010232c:	39 de                	cmp    %ebx,%esi
8010232e:	72 1c                	jb     8010234c <kinit1+0x5c>
    kfree(p);
80102330:	83 ec 0c             	sub    $0xc,%esp
80102333:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102339:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010233f:	50                   	push   %eax
80102340:	e8 5b fe ff ff       	call   801021a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102345:	83 c4 10             	add    $0x10,%esp
80102348:	39 de                	cmp    %ebx,%esi
8010234a:	73 e4                	jae    80102330 <kinit1+0x40>
}
8010234c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010234f:	5b                   	pop    %ebx
80102350:	5e                   	pop    %esi
80102351:	5d                   	pop    %ebp
80102352:	c3                   	ret
80102353:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010235a:	00 
8010235b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102360 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102360:	55                   	push   %ebp
80102361:	89 e5                	mov    %esp,%ebp
80102363:	53                   	push   %ebx
80102364:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102367:	a1 14 e6 18 80       	mov    0x8018e614,%eax
8010236c:	85 c0                	test   %eax,%eax
8010236e:	75 20                	jne    80102390 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102370:	8b 1d 18 e6 18 80    	mov    0x8018e618,%ebx
  if(r)
80102376:	85 db                	test   %ebx,%ebx
80102378:	74 07                	je     80102381 <kalloc+0x21>
    kmem.freelist = r->next;
8010237a:	8b 03                	mov    (%ebx),%eax
8010237c:	a3 18 e6 18 80       	mov    %eax,0x8018e618
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102381:	89 d8                	mov    %ebx,%eax
80102383:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102386:	c9                   	leave
80102387:	c3                   	ret
80102388:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010238f:	00 
    acquire(&kmem.lock);
80102390:	83 ec 0c             	sub    $0xc,%esp
80102393:	68 e0 e5 18 80       	push   $0x8018e5e0
80102398:	e8 03 1f 00 00       	call   801042a0 <acquire>
  r = kmem.freelist;
8010239d:	8b 1d 18 e6 18 80    	mov    0x8018e618,%ebx
  if(kmem.use_lock)
801023a3:	a1 14 e6 18 80       	mov    0x8018e614,%eax
  if(r)
801023a8:	83 c4 10             	add    $0x10,%esp
801023ab:	85 db                	test   %ebx,%ebx
801023ad:	74 08                	je     801023b7 <kalloc+0x57>
    kmem.freelist = r->next;
801023af:	8b 13                	mov    (%ebx),%edx
801023b1:	89 15 18 e6 18 80    	mov    %edx,0x8018e618
  if(kmem.use_lock)
801023b7:	85 c0                	test   %eax,%eax
801023b9:	74 c6                	je     80102381 <kalloc+0x21>
    release(&kmem.lock);
801023bb:	83 ec 0c             	sub    $0xc,%esp
801023be:	68 e0 e5 18 80       	push   $0x8018e5e0
801023c3:	e8 78 1e 00 00       	call   80104240 <release>
}
801023c8:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
801023ca:	83 c4 10             	add    $0x10,%esp
}
801023cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023d0:	c9                   	leave
801023d1:	c3                   	ret
801023d2:	66 90                	xchg   %ax,%ax
801023d4:	66 90                	xchg   %ax,%ax
801023d6:	66 90                	xchg   %ax,%ax
801023d8:	66 90                	xchg   %ax,%ax
801023da:	66 90                	xchg   %ax,%ax
801023dc:	66 90                	xchg   %ax,%ax
801023de:	66 90                	xchg   %ax,%ax

801023e0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023e0:	ba 64 00 00 00       	mov    $0x64,%edx
801023e5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801023e6:	a8 01                	test   $0x1,%al
801023e8:	0f 84 c2 00 00 00    	je     801024b0 <kbdgetc+0xd0>
{
801023ee:	55                   	push   %ebp
801023ef:	ba 60 00 00 00       	mov    $0x60,%edx
801023f4:	89 e5                	mov    %esp,%ebp
801023f6:	53                   	push   %ebx
801023f7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801023f8:	8b 1d 1c e6 18 80    	mov    0x8018e61c,%ebx
  data = inb(KBDATAP);
801023fe:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102401:	3c e0                	cmp    $0xe0,%al
80102403:	74 5b                	je     80102460 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102405:	89 da                	mov    %ebx,%edx
80102407:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010240a:	84 c0                	test   %al,%al
8010240c:	78 62                	js     80102470 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010240e:	85 d2                	test   %edx,%edx
80102410:	74 09                	je     8010241b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102412:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102415:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102418:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010241b:	0f b6 91 20 77 10 80 	movzbl -0x7fef88e0(%ecx),%edx
  shift ^= togglecode[data];
80102422:	0f b6 81 20 76 10 80 	movzbl -0x7fef89e0(%ecx),%eax
  shift |= shiftcode[data];
80102429:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010242b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010242d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010242f:	89 15 1c e6 18 80    	mov    %edx,0x8018e61c
  c = charcode[shift & (CTL | SHIFT)][data];
80102435:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102438:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010243b:	8b 04 85 00 76 10 80 	mov    -0x7fef8a00(,%eax,4),%eax
80102442:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102446:	74 0b                	je     80102453 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102448:	8d 50 9f             	lea    -0x61(%eax),%edx
8010244b:	83 fa 19             	cmp    $0x19,%edx
8010244e:	77 48                	ja     80102498 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102450:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102453:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102456:	c9                   	leave
80102457:	c3                   	ret
80102458:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010245f:	00 
    shift |= E0ESC;
80102460:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102463:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102465:	89 1d 1c e6 18 80    	mov    %ebx,0x8018e61c
}
8010246b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010246e:	c9                   	leave
8010246f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80102470:	83 e0 7f             	and    $0x7f,%eax
80102473:	85 d2                	test   %edx,%edx
80102475:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102478:	0f b6 81 20 77 10 80 	movzbl -0x7fef88e0(%ecx),%eax
8010247f:	83 c8 40             	or     $0x40,%eax
80102482:	0f b6 c0             	movzbl %al,%eax
80102485:	f7 d0                	not    %eax
80102487:	21 d8                	and    %ebx,%eax
80102489:	a3 1c e6 18 80       	mov    %eax,0x8018e61c
    return 0;
8010248e:	31 c0                	xor    %eax,%eax
80102490:	eb d9                	jmp    8010246b <kbdgetc+0x8b>
80102492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102498:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010249b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010249e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024a1:	c9                   	leave
      c += 'a' - 'A';
801024a2:	83 f9 1a             	cmp    $0x1a,%ecx
801024a5:	0f 42 c2             	cmovb  %edx,%eax
}
801024a8:	c3                   	ret
801024a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801024b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801024b5:	c3                   	ret
801024b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801024bd:	00 
801024be:	66 90                	xchg   %ax,%ax

801024c0 <kbdintr>:

void
kbdintr(void)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801024c6:	68 e0 23 10 80       	push   $0x801023e0
801024cb:	e8 d0 e3 ff ff       	call   801008a0 <consoleintr>
}
801024d0:	83 c4 10             	add    $0x10,%esp
801024d3:	c9                   	leave
801024d4:	c3                   	ret
801024d5:	66 90                	xchg   %ax,%ax
801024d7:	66 90                	xchg   %ax,%ax
801024d9:	66 90                	xchg   %ax,%ax
801024db:	66 90                	xchg   %ax,%ax
801024dd:	66 90                	xchg   %ax,%ax
801024df:	90                   	nop

801024e0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801024e0:	a1 20 e6 18 80       	mov    0x8018e620,%eax
801024e5:	85 c0                	test   %eax,%eax
801024e7:	0f 84 c3 00 00 00    	je     801025b0 <lapicinit+0xd0>
  lapic[index] = value;
801024ed:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801024f4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801024f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801024fa:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102501:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102504:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102507:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010250e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102511:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102514:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010251b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010251e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102521:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102528:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010252b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010252e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102535:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102538:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010253b:	8b 50 30             	mov    0x30(%eax),%edx
8010253e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80102544:	75 72                	jne    801025b8 <lapicinit+0xd8>
  lapic[index] = value;
80102546:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
8010254d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102550:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102553:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010255a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010255d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102560:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102567:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010256a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010256d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102574:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102577:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010257a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102581:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102584:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102587:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
8010258e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102591:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102598:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010259e:	80 e6 10             	and    $0x10,%dh
801025a1:	75 f5                	jne    80102598 <lapicinit+0xb8>
  lapic[index] = value;
801025a3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801025aa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025ad:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801025b0:	c3                   	ret
801025b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801025b8:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801025bf:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801025c2:	8b 50 20             	mov    0x20(%eax),%edx
}
801025c5:	e9 7c ff ff ff       	jmp    80102546 <lapicinit+0x66>
801025ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801025d0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801025d0:	a1 20 e6 18 80       	mov    0x8018e620,%eax
801025d5:	85 c0                	test   %eax,%eax
801025d7:	74 07                	je     801025e0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801025d9:	8b 40 20             	mov    0x20(%eax),%eax
801025dc:	c1 e8 18             	shr    $0x18,%eax
801025df:	c3                   	ret
    return 0;
801025e0:	31 c0                	xor    %eax,%eax
}
801025e2:	c3                   	ret
801025e3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801025ea:	00 
801025eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801025f0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801025f0:	a1 20 e6 18 80       	mov    0x8018e620,%eax
801025f5:	85 c0                	test   %eax,%eax
801025f7:	74 0d                	je     80102606 <lapiceoi+0x16>
  lapic[index] = value;
801025f9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102600:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102603:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102606:	c3                   	ret
80102607:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010260e:	00 
8010260f:	90                   	nop

80102610 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102610:	c3                   	ret
80102611:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102618:	00 
80102619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102620 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102620:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102621:	b8 0f 00 00 00       	mov    $0xf,%eax
80102626:	ba 70 00 00 00       	mov    $0x70,%edx
8010262b:	89 e5                	mov    %esp,%ebp
8010262d:	53                   	push   %ebx
8010262e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102631:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102634:	ee                   	out    %al,(%dx)
80102635:	b8 0a 00 00 00       	mov    $0xa,%eax
8010263a:	ba 71 00 00 00       	mov    $0x71,%edx
8010263f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102640:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102642:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102645:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010264b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010264d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102650:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102652:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102655:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102658:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010265e:	a1 20 e6 18 80       	mov    0x8018e620,%eax
80102663:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102669:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010266c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102673:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102676:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102679:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102680:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102683:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102686:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010268c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010268f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102695:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102698:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010269e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801026a7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801026aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026ad:	c9                   	leave
801026ae:	c3                   	ret
801026af:	90                   	nop

801026b0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801026b0:	55                   	push   %ebp
801026b1:	b8 0b 00 00 00       	mov    $0xb,%eax
801026b6:	ba 70 00 00 00       	mov    $0x70,%edx
801026bb:	89 e5                	mov    %esp,%ebp
801026bd:	57                   	push   %edi
801026be:	56                   	push   %esi
801026bf:	53                   	push   %ebx
801026c0:	83 ec 4c             	sub    $0x4c,%esp
801026c3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026c4:	ba 71 00 00 00       	mov    $0x71,%edx
801026c9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801026ca:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026cd:	bf 70 00 00 00       	mov    $0x70,%edi
801026d2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801026d5:	8d 76 00             	lea    0x0(%esi),%esi
801026d8:	31 c0                	xor    %eax,%eax
801026da:	89 fa                	mov    %edi,%edx
801026dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026dd:	b9 71 00 00 00       	mov    $0x71,%ecx
801026e2:	89 ca                	mov    %ecx,%edx
801026e4:	ec                   	in     (%dx),%al
801026e5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026e8:	89 fa                	mov    %edi,%edx
801026ea:	b8 02 00 00 00       	mov    $0x2,%eax
801026ef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026f0:	89 ca                	mov    %ecx,%edx
801026f2:	ec                   	in     (%dx),%al
801026f3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026f6:	89 fa                	mov    %edi,%edx
801026f8:	b8 04 00 00 00       	mov    $0x4,%eax
801026fd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026fe:	89 ca                	mov    %ecx,%edx
80102700:	ec                   	in     (%dx),%al
80102701:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102704:	89 fa                	mov    %edi,%edx
80102706:	b8 07 00 00 00       	mov    $0x7,%eax
8010270b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010270c:	89 ca                	mov    %ecx,%edx
8010270e:	ec                   	in     (%dx),%al
8010270f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102712:	89 fa                	mov    %edi,%edx
80102714:	b8 08 00 00 00       	mov    $0x8,%eax
80102719:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010271a:	89 ca                	mov    %ecx,%edx
8010271c:	ec                   	in     (%dx),%al
8010271d:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010271f:	89 fa                	mov    %edi,%edx
80102721:	b8 09 00 00 00       	mov    $0x9,%eax
80102726:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102727:	89 ca                	mov    %ecx,%edx
80102729:	ec                   	in     (%dx),%al
8010272a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010272d:	89 fa                	mov    %edi,%edx
8010272f:	b8 0a 00 00 00       	mov    $0xa,%eax
80102734:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102735:	89 ca                	mov    %ecx,%edx
80102737:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102738:	84 c0                	test   %al,%al
8010273a:	78 9c                	js     801026d8 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010273c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102740:	89 f2                	mov    %esi,%edx
80102742:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102745:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102748:	89 fa                	mov    %edi,%edx
8010274a:	89 45 b8             	mov    %eax,-0x48(%ebp)
8010274d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102751:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102754:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102757:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010275b:	89 45 c0             	mov    %eax,-0x40(%ebp)
8010275e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102762:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102765:	31 c0                	xor    %eax,%eax
80102767:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102768:	89 ca                	mov    %ecx,%edx
8010276a:	ec                   	in     (%dx),%al
8010276b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010276e:	89 fa                	mov    %edi,%edx
80102770:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102773:	b8 02 00 00 00       	mov    $0x2,%eax
80102778:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102779:	89 ca                	mov    %ecx,%edx
8010277b:	ec                   	in     (%dx),%al
8010277c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010277f:	89 fa                	mov    %edi,%edx
80102781:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102784:	b8 04 00 00 00       	mov    $0x4,%eax
80102789:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010278a:	89 ca                	mov    %ecx,%edx
8010278c:	ec                   	in     (%dx),%al
8010278d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102790:	89 fa                	mov    %edi,%edx
80102792:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102795:	b8 07 00 00 00       	mov    $0x7,%eax
8010279a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010279b:	89 ca                	mov    %ecx,%edx
8010279d:	ec                   	in     (%dx),%al
8010279e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027a1:	89 fa                	mov    %edi,%edx
801027a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801027a6:	b8 08 00 00 00       	mov    $0x8,%eax
801027ab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027ac:	89 ca                	mov    %ecx,%edx
801027ae:	ec                   	in     (%dx),%al
801027af:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027b2:	89 fa                	mov    %edi,%edx
801027b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
801027b7:	b8 09 00 00 00       	mov    $0x9,%eax
801027bc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027bd:	89 ca                	mov    %ecx,%edx
801027bf:	ec                   	in     (%dx),%al
801027c0:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801027c3:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
801027c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801027c9:	8d 45 d0             	lea    -0x30(%ebp),%eax
801027cc:	6a 18                	push   $0x18
801027ce:	50                   	push   %eax
801027cf:	8d 45 b8             	lea    -0x48(%ebp),%eax
801027d2:	50                   	push   %eax
801027d3:	e8 08 1c 00 00       	call   801043e0 <memcmp>
801027d8:	83 c4 10             	add    $0x10,%esp
801027db:	85 c0                	test   %eax,%eax
801027dd:	0f 85 f5 fe ff ff    	jne    801026d8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801027e3:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
801027e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801027ea:	89 f0                	mov    %esi,%eax
801027ec:	84 c0                	test   %al,%al
801027ee:	75 78                	jne    80102868 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801027f0:	8b 45 b8             	mov    -0x48(%ebp),%eax
801027f3:	89 c2                	mov    %eax,%edx
801027f5:	83 e0 0f             	and    $0xf,%eax
801027f8:	c1 ea 04             	shr    $0x4,%edx
801027fb:	8d 14 92             	lea    (%edx,%edx,4),%edx
801027fe:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102801:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102804:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102807:	89 c2                	mov    %eax,%edx
80102809:	83 e0 0f             	and    $0xf,%eax
8010280c:	c1 ea 04             	shr    $0x4,%edx
8010280f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102812:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102815:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102818:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010281b:	89 c2                	mov    %eax,%edx
8010281d:	83 e0 0f             	and    $0xf,%eax
80102820:	c1 ea 04             	shr    $0x4,%edx
80102823:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102826:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102829:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
8010282c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010282f:	89 c2                	mov    %eax,%edx
80102831:	83 e0 0f             	and    $0xf,%eax
80102834:	c1 ea 04             	shr    $0x4,%edx
80102837:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010283a:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010283d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102840:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102843:	89 c2                	mov    %eax,%edx
80102845:	83 e0 0f             	and    $0xf,%eax
80102848:	c1 ea 04             	shr    $0x4,%edx
8010284b:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010284e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102851:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102854:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102857:	89 c2                	mov    %eax,%edx
80102859:	83 e0 0f             	and    $0xf,%eax
8010285c:	c1 ea 04             	shr    $0x4,%edx
8010285f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102862:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102865:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102868:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010286b:	89 03                	mov    %eax,(%ebx)
8010286d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102870:	89 43 04             	mov    %eax,0x4(%ebx)
80102873:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102876:	89 43 08             	mov    %eax,0x8(%ebx)
80102879:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010287c:	89 43 0c             	mov    %eax,0xc(%ebx)
8010287f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102882:	89 43 10             	mov    %eax,0x10(%ebx)
80102885:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102888:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
8010288b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102892:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102895:	5b                   	pop    %ebx
80102896:	5e                   	pop    %esi
80102897:	5f                   	pop    %edi
80102898:	5d                   	pop    %ebp
80102899:	c3                   	ret
8010289a:	66 90                	xchg   %ax,%ax
8010289c:	66 90                	xchg   %ax,%ax
8010289e:	66 90                	xchg   %ax,%ax

801028a0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801028a0:	8b 0d 88 e6 18 80    	mov    0x8018e688,%ecx
801028a6:	85 c9                	test   %ecx,%ecx
801028a8:	0f 8e 8a 00 00 00    	jle    80102938 <install_trans+0x98>
{
801028ae:	55                   	push   %ebp
801028af:	89 e5                	mov    %esp,%ebp
801028b1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
801028b2:	31 ff                	xor    %edi,%edi
{
801028b4:	56                   	push   %esi
801028b5:	53                   	push   %ebx
801028b6:	83 ec 0c             	sub    $0xc,%esp
801028b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801028c0:	a1 74 e6 18 80       	mov    0x8018e674,%eax
801028c5:	83 ec 08             	sub    $0x8,%esp
801028c8:	01 f8                	add    %edi,%eax
801028ca:	83 c0 01             	add    $0x1,%eax
801028cd:	50                   	push   %eax
801028ce:	ff 35 84 e6 18 80    	push   0x8018e684
801028d4:	e8 f7 d7 ff ff       	call   801000d0 <bread>
801028d9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801028db:	58                   	pop    %eax
801028dc:	5a                   	pop    %edx
801028dd:	ff 34 bd 8c e6 18 80 	push   -0x7fe71974(,%edi,4)
801028e4:	ff 35 84 e6 18 80    	push   0x8018e684
  for (tail = 0; tail < log.lh.n; tail++) {
801028ea:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801028ed:	e8 de d7 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801028f2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801028f5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801028f7:	8d 46 5c             	lea    0x5c(%esi),%eax
801028fa:	68 00 02 00 00       	push   $0x200
801028ff:	50                   	push   %eax
80102900:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102903:	50                   	push   %eax
80102904:	e8 27 1b 00 00       	call   80104430 <memmove>
    bwrite(dbuf);  // write dst to disk
80102909:	89 1c 24             	mov    %ebx,(%esp)
8010290c:	e8 9f d8 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102911:	89 34 24             	mov    %esi,(%esp)
80102914:	e8 d7 d8 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102919:	89 1c 24             	mov    %ebx,(%esp)
8010291c:	e8 cf d8 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102921:	83 c4 10             	add    $0x10,%esp
80102924:	39 3d 88 e6 18 80    	cmp    %edi,0x8018e688
8010292a:	7f 94                	jg     801028c0 <install_trans+0x20>
  }
}
8010292c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010292f:	5b                   	pop    %ebx
80102930:	5e                   	pop    %esi
80102931:	5f                   	pop    %edi
80102932:	5d                   	pop    %ebp
80102933:	c3                   	ret
80102934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102938:	c3                   	ret
80102939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102940 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102940:	55                   	push   %ebp
80102941:	89 e5                	mov    %esp,%ebp
80102943:	53                   	push   %ebx
80102944:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102947:	ff 35 74 e6 18 80    	push   0x8018e674
8010294d:	ff 35 84 e6 18 80    	push   0x8018e684
80102953:	e8 78 d7 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102958:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010295b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010295d:	a1 88 e6 18 80       	mov    0x8018e688,%eax
80102962:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102965:	85 c0                	test   %eax,%eax
80102967:	7e 19                	jle    80102982 <write_head+0x42>
80102969:	31 d2                	xor    %edx,%edx
8010296b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102970:	8b 0c 95 8c e6 18 80 	mov    -0x7fe71974(,%edx,4),%ecx
80102977:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010297b:	83 c2 01             	add    $0x1,%edx
8010297e:	39 d0                	cmp    %edx,%eax
80102980:	75 ee                	jne    80102970 <write_head+0x30>
  }
  bwrite(buf);
80102982:	83 ec 0c             	sub    $0xc,%esp
80102985:	53                   	push   %ebx
80102986:	e8 25 d8 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010298b:	89 1c 24             	mov    %ebx,(%esp)
8010298e:	e8 5d d8 ff ff       	call   801001f0 <brelse>
}
80102993:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102996:	83 c4 10             	add    $0x10,%esp
80102999:	c9                   	leave
8010299a:	c3                   	ret
8010299b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801029a0 <initlog>:
{
801029a0:	55                   	push   %ebp
801029a1:	89 e5                	mov    %esp,%ebp
801029a3:	53                   	push   %ebx
801029a4:	83 ec 2c             	sub    $0x2c,%esp
801029a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801029aa:	68 cf 70 10 80       	push   $0x801070cf
801029af:	68 40 e6 18 80       	push   $0x8018e640
801029b4:	e8 f7 16 00 00       	call   801040b0 <initlock>
  readsb(dev, &sb);
801029b9:	58                   	pop    %eax
801029ba:	8d 45 dc             	lea    -0x24(%ebp),%eax
801029bd:	5a                   	pop    %edx
801029be:	50                   	push   %eax
801029bf:	53                   	push   %ebx
801029c0:	e8 7b eb ff ff       	call   80101540 <readsb>
  log.start = sb.logstart;
801029c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
801029c8:	59                   	pop    %ecx
  log.dev = dev;
801029c9:	89 1d 84 e6 18 80    	mov    %ebx,0x8018e684
  log.size = sb.nlog;
801029cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801029d2:	a3 74 e6 18 80       	mov    %eax,0x8018e674
  log.size = sb.nlog;
801029d7:	89 15 78 e6 18 80    	mov    %edx,0x8018e678
  struct buf *buf = bread(log.dev, log.start);
801029dd:	5a                   	pop    %edx
801029de:	50                   	push   %eax
801029df:	53                   	push   %ebx
801029e0:	e8 eb d6 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
801029e5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
801029e8:	8b 58 5c             	mov    0x5c(%eax),%ebx
801029eb:	89 1d 88 e6 18 80    	mov    %ebx,0x8018e688
  for (i = 0; i < log.lh.n; i++) {
801029f1:	85 db                	test   %ebx,%ebx
801029f3:	7e 1d                	jle    80102a12 <initlog+0x72>
801029f5:	31 d2                	xor    %edx,%edx
801029f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801029fe:	00 
801029ff:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102a00:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102a04:	89 0c 95 8c e6 18 80 	mov    %ecx,-0x7fe71974(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102a0b:	83 c2 01             	add    $0x1,%edx
80102a0e:	39 d3                	cmp    %edx,%ebx
80102a10:	75 ee                	jne    80102a00 <initlog+0x60>
  brelse(buf);
80102a12:	83 ec 0c             	sub    $0xc,%esp
80102a15:	50                   	push   %eax
80102a16:	e8 d5 d7 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102a1b:	e8 80 fe ff ff       	call   801028a0 <install_trans>
  log.lh.n = 0;
80102a20:	c7 05 88 e6 18 80 00 	movl   $0x0,0x8018e688
80102a27:	00 00 00 
  write_head(); // clear the log
80102a2a:	e8 11 ff ff ff       	call   80102940 <write_head>
}
80102a2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a32:	83 c4 10             	add    $0x10,%esp
80102a35:	c9                   	leave
80102a36:	c3                   	ret
80102a37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102a3e:	00 
80102a3f:	90                   	nop

80102a40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102a40:	55                   	push   %ebp
80102a41:	89 e5                	mov    %esp,%ebp
80102a43:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102a46:	68 40 e6 18 80       	push   $0x8018e640
80102a4b:	e8 50 18 00 00       	call   801042a0 <acquire>
80102a50:	83 c4 10             	add    $0x10,%esp
80102a53:	eb 18                	jmp    80102a6d <begin_op+0x2d>
80102a55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102a58:	83 ec 08             	sub    $0x8,%esp
80102a5b:	68 40 e6 18 80       	push   $0x8018e640
80102a60:	68 40 e6 18 80       	push   $0x8018e640
80102a65:	e8 b6 12 00 00       	call   80103d20 <sleep>
80102a6a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102a6d:	a1 80 e6 18 80       	mov    0x8018e680,%eax
80102a72:	85 c0                	test   %eax,%eax
80102a74:	75 e2                	jne    80102a58 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102a76:	a1 7c e6 18 80       	mov    0x8018e67c,%eax
80102a7b:	8b 15 88 e6 18 80    	mov    0x8018e688,%edx
80102a81:	83 c0 01             	add    $0x1,%eax
80102a84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102a87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102a8a:	83 fa 1e             	cmp    $0x1e,%edx
80102a8d:	7f c9                	jg     80102a58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102a8f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102a92:	a3 7c e6 18 80       	mov    %eax,0x8018e67c
      release(&log.lock);
80102a97:	68 40 e6 18 80       	push   $0x8018e640
80102a9c:	e8 9f 17 00 00       	call   80104240 <release>
      break;
    }
  }
}
80102aa1:	83 c4 10             	add    $0x10,%esp
80102aa4:	c9                   	leave
80102aa5:	c3                   	ret
80102aa6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102aad:	00 
80102aae:	66 90                	xchg   %ax,%ax

80102ab0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102ab0:	55                   	push   %ebp
80102ab1:	89 e5                	mov    %esp,%ebp
80102ab3:	57                   	push   %edi
80102ab4:	56                   	push   %esi
80102ab5:	53                   	push   %ebx
80102ab6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102ab9:	68 40 e6 18 80       	push   $0x8018e640
80102abe:	e8 dd 17 00 00       	call   801042a0 <acquire>
  log.outstanding -= 1;
80102ac3:	a1 7c e6 18 80       	mov    0x8018e67c,%eax
  if(log.committing)
80102ac8:	8b 35 80 e6 18 80    	mov    0x8018e680,%esi
80102ace:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102ad1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102ad4:	89 1d 7c e6 18 80    	mov    %ebx,0x8018e67c
  if(log.committing)
80102ada:	85 f6                	test   %esi,%esi
80102adc:	0f 85 22 01 00 00    	jne    80102c04 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102ae2:	85 db                	test   %ebx,%ebx
80102ae4:	0f 85 f6 00 00 00    	jne    80102be0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102aea:	c7 05 80 e6 18 80 01 	movl   $0x1,0x8018e680
80102af1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102af4:	83 ec 0c             	sub    $0xc,%esp
80102af7:	68 40 e6 18 80       	push   $0x8018e640
80102afc:	e8 3f 17 00 00       	call   80104240 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102b01:	8b 0d 88 e6 18 80    	mov    0x8018e688,%ecx
80102b07:	83 c4 10             	add    $0x10,%esp
80102b0a:	85 c9                	test   %ecx,%ecx
80102b0c:	7f 42                	jg     80102b50 <end_op+0xa0>
    acquire(&log.lock);
80102b0e:	83 ec 0c             	sub    $0xc,%esp
80102b11:	68 40 e6 18 80       	push   $0x8018e640
80102b16:	e8 85 17 00 00       	call   801042a0 <acquire>
    log.committing = 0;
80102b1b:	c7 05 80 e6 18 80 00 	movl   $0x0,0x8018e680
80102b22:	00 00 00 
    wakeup(&log);
80102b25:	c7 04 24 40 e6 18 80 	movl   $0x8018e640,(%esp)
80102b2c:	e8 af 12 00 00       	call   80103de0 <wakeup>
    release(&log.lock);
80102b31:	c7 04 24 40 e6 18 80 	movl   $0x8018e640,(%esp)
80102b38:	e8 03 17 00 00       	call   80104240 <release>
80102b3d:	83 c4 10             	add    $0x10,%esp
}
80102b40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b43:	5b                   	pop    %ebx
80102b44:	5e                   	pop    %esi
80102b45:	5f                   	pop    %edi
80102b46:	5d                   	pop    %ebp
80102b47:	c3                   	ret
80102b48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102b4f:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102b50:	a1 74 e6 18 80       	mov    0x8018e674,%eax
80102b55:	83 ec 08             	sub    $0x8,%esp
80102b58:	01 d8                	add    %ebx,%eax
80102b5a:	83 c0 01             	add    $0x1,%eax
80102b5d:	50                   	push   %eax
80102b5e:	ff 35 84 e6 18 80    	push   0x8018e684
80102b64:	e8 67 d5 ff ff       	call   801000d0 <bread>
80102b69:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102b6b:	58                   	pop    %eax
80102b6c:	5a                   	pop    %edx
80102b6d:	ff 34 9d 8c e6 18 80 	push   -0x7fe71974(,%ebx,4)
80102b74:	ff 35 84 e6 18 80    	push   0x8018e684
  for (tail = 0; tail < log.lh.n; tail++) {
80102b7a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102b7d:	e8 4e d5 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102b82:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102b85:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102b87:	8d 40 5c             	lea    0x5c(%eax),%eax
80102b8a:	68 00 02 00 00       	push   $0x200
80102b8f:	50                   	push   %eax
80102b90:	8d 46 5c             	lea    0x5c(%esi),%eax
80102b93:	50                   	push   %eax
80102b94:	e8 97 18 00 00       	call   80104430 <memmove>
    bwrite(to);  // write the log
80102b99:	89 34 24             	mov    %esi,(%esp)
80102b9c:	e8 0f d6 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ba1:	89 3c 24             	mov    %edi,(%esp)
80102ba4:	e8 47 d6 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ba9:	89 34 24             	mov    %esi,(%esp)
80102bac:	e8 3f d6 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102bb1:	83 c4 10             	add    $0x10,%esp
80102bb4:	3b 1d 88 e6 18 80    	cmp    0x8018e688,%ebx
80102bba:	7c 94                	jl     80102b50 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102bbc:	e8 7f fd ff ff       	call   80102940 <write_head>
    install_trans(); // Now install writes to home locations
80102bc1:	e8 da fc ff ff       	call   801028a0 <install_trans>
    log.lh.n = 0;
80102bc6:	c7 05 88 e6 18 80 00 	movl   $0x0,0x8018e688
80102bcd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102bd0:	e8 6b fd ff ff       	call   80102940 <write_head>
80102bd5:	e9 34 ff ff ff       	jmp    80102b0e <end_op+0x5e>
80102bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102be0:	83 ec 0c             	sub    $0xc,%esp
80102be3:	68 40 e6 18 80       	push   $0x8018e640
80102be8:	e8 f3 11 00 00       	call   80103de0 <wakeup>
  release(&log.lock);
80102bed:	c7 04 24 40 e6 18 80 	movl   $0x8018e640,(%esp)
80102bf4:	e8 47 16 00 00       	call   80104240 <release>
80102bf9:	83 c4 10             	add    $0x10,%esp
}
80102bfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bff:	5b                   	pop    %ebx
80102c00:	5e                   	pop    %esi
80102c01:	5f                   	pop    %edi
80102c02:	5d                   	pop    %ebp
80102c03:	c3                   	ret
    panic("log.committing");
80102c04:	83 ec 0c             	sub    $0xc,%esp
80102c07:	68 d3 70 10 80       	push   $0x801070d3
80102c0c:	e8 6f d7 ff ff       	call   80100380 <panic>
80102c11:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102c18:	00 
80102c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c20 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
80102c23:	53                   	push   %ebx
80102c24:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102c27:	8b 15 88 e6 18 80    	mov    0x8018e688,%edx
{
80102c2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102c30:	83 fa 1d             	cmp    $0x1d,%edx
80102c33:	7f 7d                	jg     80102cb2 <log_write+0x92>
80102c35:	a1 78 e6 18 80       	mov    0x8018e678,%eax
80102c3a:	83 e8 01             	sub    $0x1,%eax
80102c3d:	39 c2                	cmp    %eax,%edx
80102c3f:	7d 71                	jge    80102cb2 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102c41:	a1 7c e6 18 80       	mov    0x8018e67c,%eax
80102c46:	85 c0                	test   %eax,%eax
80102c48:	7e 75                	jle    80102cbf <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102c4a:	83 ec 0c             	sub    $0xc,%esp
80102c4d:	68 40 e6 18 80       	push   $0x8018e640
80102c52:	e8 49 16 00 00       	call   801042a0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102c57:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102c5a:	83 c4 10             	add    $0x10,%esp
80102c5d:	31 c0                	xor    %eax,%eax
80102c5f:	8b 15 88 e6 18 80    	mov    0x8018e688,%edx
80102c65:	85 d2                	test   %edx,%edx
80102c67:	7f 0e                	jg     80102c77 <log_write+0x57>
80102c69:	eb 15                	jmp    80102c80 <log_write+0x60>
80102c6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80102c70:	83 c0 01             	add    $0x1,%eax
80102c73:	39 c2                	cmp    %eax,%edx
80102c75:	74 29                	je     80102ca0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102c77:	39 0c 85 8c e6 18 80 	cmp    %ecx,-0x7fe71974(,%eax,4)
80102c7e:	75 f0                	jne    80102c70 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102c80:	89 0c 85 8c e6 18 80 	mov    %ecx,-0x7fe71974(,%eax,4)
  if (i == log.lh.n)
80102c87:	39 c2                	cmp    %eax,%edx
80102c89:	74 1c                	je     80102ca7 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102c8b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102c8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102c91:	c7 45 08 40 e6 18 80 	movl   $0x8018e640,0x8(%ebp)
}
80102c98:	c9                   	leave
  release(&log.lock);
80102c99:	e9 a2 15 00 00       	jmp    80104240 <release>
80102c9e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80102ca0:	89 0c 95 8c e6 18 80 	mov    %ecx,-0x7fe71974(,%edx,4)
    log.lh.n++;
80102ca7:	83 c2 01             	add    $0x1,%edx
80102caa:	89 15 88 e6 18 80    	mov    %edx,0x8018e688
80102cb0:	eb d9                	jmp    80102c8b <log_write+0x6b>
    panic("too big a transaction");
80102cb2:	83 ec 0c             	sub    $0xc,%esp
80102cb5:	68 e2 70 10 80       	push   $0x801070e2
80102cba:	e8 c1 d6 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102cbf:	83 ec 0c             	sub    $0xc,%esp
80102cc2:	68 f8 70 10 80       	push   $0x801070f8
80102cc7:	e8 b4 d6 ff ff       	call   80100380 <panic>
80102ccc:	66 90                	xchg   %ax,%ax
80102cce:	66 90                	xchg   %ax,%ax

80102cd0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102cd0:	55                   	push   %ebp
80102cd1:	89 e5                	mov    %esp,%ebp
80102cd3:	53                   	push   %ebx
80102cd4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102cd7:	e8 64 09 00 00       	call   80103640 <cpuid>
80102cdc:	89 c3                	mov    %eax,%ebx
80102cde:	e8 5d 09 00 00       	call   80103640 <cpuid>
80102ce3:	83 ec 04             	sub    $0x4,%esp
80102ce6:	53                   	push   %ebx
80102ce7:	50                   	push   %eax
80102ce8:	68 13 71 10 80       	push   $0x80107113
80102ced:	e8 be d9 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80102cf2:	e8 e9 28 00 00       	call   801055e0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102cf7:	e8 e4 08 00 00       	call   801035e0 <mycpu>
80102cfc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102cfe:	b8 01 00 00 00       	mov    $0x1,%eax
80102d03:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102d0a:	e8 01 0c 00 00       	call   80103910 <scheduler>
80102d0f:	90                   	nop

80102d10 <mpenter>:
{
80102d10:	55                   	push   %ebp
80102d11:	89 e5                	mov    %esp,%ebp
80102d13:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102d16:	e8 c5 39 00 00       	call   801066e0 <switchkvm>
  seginit();
80102d1b:	e8 30 39 00 00       	call   80106650 <seginit>
  lapicinit();
80102d20:	e8 bb f7 ff ff       	call   801024e0 <lapicinit>
  mpmain();
80102d25:	e8 a6 ff ff ff       	call   80102cd0 <mpmain>
80102d2a:	66 90                	xchg   %ax,%ax
80102d2c:	66 90                	xchg   %ax,%ax
80102d2e:	66 90                	xchg   %ax,%ax

80102d30 <main>:
{
80102d30:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102d34:	83 e4 f0             	and    $0xfffffff0,%esp
80102d37:	ff 71 fc             	push   -0x4(%ecx)
80102d3a:	55                   	push   %ebp
80102d3b:	89 e5                	mov    %esp,%ebp
80102d3d:	53                   	push   %ebx
80102d3e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102d3f:	83 ec 08             	sub    $0x8,%esp
80102d42:	68 00 00 40 80       	push   $0x80400000
80102d47:	68 70 24 19 80       	push   $0x80192470
80102d4c:	e8 9f f5 ff ff       	call   801022f0 <kinit1>
  kvmalloc();      // kernel page table
80102d51:	e8 4a 3e 00 00       	call   80106ba0 <kvmalloc>
  mpinit();        // detect other processors
80102d56:	e8 85 01 00 00       	call   80102ee0 <mpinit>
  lapicinit();     // interrupt controller
80102d5b:	e8 80 f7 ff ff       	call   801024e0 <lapicinit>
  seginit();       // segment descriptors
80102d60:	e8 eb 38 00 00       	call   80106650 <seginit>
  picinit();       // disable pic
80102d65:	e8 86 03 00 00       	call   801030f0 <picinit>
  ioapicinit();    // another interrupt controller
80102d6a:	e8 51 f3 ff ff       	call   801020c0 <ioapicinit>
  consoleinit();   // console hardware
80102d6f:	e8 ec dc ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
80102d74:	e8 47 2b 00 00       	call   801058c0 <uartinit>
  pinit();         // process table
80102d79:	e8 42 08 00 00       	call   801035c0 <pinit>
  tvinit();        // trap vectors
80102d7e:	e8 dd 27 00 00       	call   80105560 <tvinit>
  binit();         // buffer cache
80102d83:	e8 b8 d2 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102d88:	e8 a3 e0 ff ff       	call   80100e30 <fileinit>
  ideinit();       // disk 
80102d8d:	e8 ce 40 00 00       	call   80106e60 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102d92:	83 c4 0c             	add    $0xc,%esp
80102d95:	68 8a 00 00 00       	push   $0x8a
80102d9a:	68 8c a4 10 80       	push   $0x8010a48c
80102d9f:	68 00 70 00 80       	push   $0x80007000
80102da4:	e8 87 16 00 00       	call   80104430 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102da9:	83 c4 10             	add    $0x10,%esp
80102dac:	69 05 24 e7 18 80 b0 	imul   $0xb0,0x8018e724,%eax
80102db3:	00 00 00 
80102db6:	05 40 e7 18 80       	add    $0x8018e740,%eax
80102dbb:	3d 40 e7 18 80       	cmp    $0x8018e740,%eax
80102dc0:	76 7e                	jbe    80102e40 <main+0x110>
80102dc2:	bb 40 e7 18 80       	mov    $0x8018e740,%ebx
80102dc7:	eb 20                	jmp    80102de9 <main+0xb9>
80102dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dd0:	69 05 24 e7 18 80 b0 	imul   $0xb0,0x8018e724,%eax
80102dd7:	00 00 00 
80102dda:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102de0:	05 40 e7 18 80       	add    $0x8018e740,%eax
80102de5:	39 c3                	cmp    %eax,%ebx
80102de7:	73 57                	jae    80102e40 <main+0x110>
    if(c == mycpu())  // We've started already.
80102de9:	e8 f2 07 00 00       	call   801035e0 <mycpu>
80102dee:	39 c3                	cmp    %eax,%ebx
80102df0:	74 de                	je     80102dd0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102df2:	e8 69 f5 ff ff       	call   80102360 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102df7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
80102dfa:	c7 05 f8 6f 00 80 10 	movl   $0x80102d10,0x80006ff8
80102e01:	2d 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102e04:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102e0b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102e0e:	05 00 10 00 00       	add    $0x1000,%eax
80102e13:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80102e18:	0f b6 03             	movzbl (%ebx),%eax
80102e1b:	68 00 70 00 00       	push   $0x7000
80102e20:	50                   	push   %eax
80102e21:	e8 fa f7 ff ff       	call   80102620 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102e26:	83 c4 10             	add    $0x10,%esp
80102e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e30:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102e36:	85 c0                	test   %eax,%eax
80102e38:	74 f6                	je     80102e30 <main+0x100>
80102e3a:	eb 94                	jmp    80102dd0 <main+0xa0>
80102e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102e40:	83 ec 08             	sub    $0x8,%esp
80102e43:	68 00 00 00 8e       	push   $0x8e000000
80102e48:	68 00 00 40 80       	push   $0x80400000
80102e4d:	e8 3e f4 ff ff       	call   80102290 <kinit2>
  userinit();      // first user process
80102e52:	e8 39 08 00 00       	call   80103690 <userinit>
  mpmain();        // finish this processor's setup
80102e57:	e8 74 fe ff ff       	call   80102cd0 <mpmain>
80102e5c:	66 90                	xchg   %ax,%ax
80102e5e:	66 90                	xchg   %ax,%ax

80102e60 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102e60:	55                   	push   %ebp
80102e61:	89 e5                	mov    %esp,%ebp
80102e63:	57                   	push   %edi
80102e64:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102e65:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102e6b:	53                   	push   %ebx
  e = addr+len;
80102e6c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102e6f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102e72:	39 de                	cmp    %ebx,%esi
80102e74:	72 10                	jb     80102e86 <mpsearch1+0x26>
80102e76:	eb 50                	jmp    80102ec8 <mpsearch1+0x68>
80102e78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e7f:	00 
80102e80:	89 fe                	mov    %edi,%esi
80102e82:	39 df                	cmp    %ebx,%edi
80102e84:	73 42                	jae    80102ec8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102e86:	83 ec 04             	sub    $0x4,%esp
80102e89:	8d 7e 10             	lea    0x10(%esi),%edi
80102e8c:	6a 04                	push   $0x4
80102e8e:	68 27 71 10 80       	push   $0x80107127
80102e93:	56                   	push   %esi
80102e94:	e8 47 15 00 00       	call   801043e0 <memcmp>
80102e99:	83 c4 10             	add    $0x10,%esp
80102e9c:	85 c0                	test   %eax,%eax
80102e9e:	75 e0                	jne    80102e80 <mpsearch1+0x20>
80102ea0:	89 f2                	mov    %esi,%edx
80102ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80102ea8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80102eab:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102eae:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80102eb0:	39 fa                	cmp    %edi,%edx
80102eb2:	75 f4                	jne    80102ea8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102eb4:	84 c0                	test   %al,%al
80102eb6:	75 c8                	jne    80102e80 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80102eb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ebb:	89 f0                	mov    %esi,%eax
80102ebd:	5b                   	pop    %ebx
80102ebe:	5e                   	pop    %esi
80102ebf:	5f                   	pop    %edi
80102ec0:	5d                   	pop    %ebp
80102ec1:	c3                   	ret
80102ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102ec8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80102ecb:	31 f6                	xor    %esi,%esi
}
80102ecd:	5b                   	pop    %ebx
80102ece:	89 f0                	mov    %esi,%eax
80102ed0:	5e                   	pop    %esi
80102ed1:	5f                   	pop    %edi
80102ed2:	5d                   	pop    %ebp
80102ed3:	c3                   	ret
80102ed4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102edb:	00 
80102edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ee0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102ee0:	55                   	push   %ebp
80102ee1:	89 e5                	mov    %esp,%ebp
80102ee3:	57                   	push   %edi
80102ee4:	56                   	push   %esi
80102ee5:	53                   	push   %ebx
80102ee6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102ee9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102ef0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102ef7:	c1 e0 08             	shl    $0x8,%eax
80102efa:	09 d0                	or     %edx,%eax
80102efc:	c1 e0 04             	shl    $0x4,%eax
80102eff:	75 1b                	jne    80102f1c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102f01:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102f08:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102f0f:	c1 e0 08             	shl    $0x8,%eax
80102f12:	09 d0                	or     %edx,%eax
80102f14:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102f17:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80102f1c:	ba 00 04 00 00       	mov    $0x400,%edx
80102f21:	e8 3a ff ff ff       	call   80102e60 <mpsearch1>
80102f26:	89 c3                	mov    %eax,%ebx
80102f28:	85 c0                	test   %eax,%eax
80102f2a:	0f 84 58 01 00 00    	je     80103088 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102f30:	8b 73 04             	mov    0x4(%ebx),%esi
80102f33:	85 f6                	test   %esi,%esi
80102f35:	0f 84 3d 01 00 00    	je     80103078 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
80102f3b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102f3e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80102f44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80102f47:	6a 04                	push   $0x4
80102f49:	68 2c 71 10 80       	push   $0x8010712c
80102f4e:	50                   	push   %eax
80102f4f:	e8 8c 14 00 00       	call   801043e0 <memcmp>
80102f54:	83 c4 10             	add    $0x10,%esp
80102f57:	85 c0                	test   %eax,%eax
80102f59:	0f 85 19 01 00 00    	jne    80103078 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
80102f5f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80102f66:	3c 01                	cmp    $0x1,%al
80102f68:	74 08                	je     80102f72 <mpinit+0x92>
80102f6a:	3c 04                	cmp    $0x4,%al
80102f6c:	0f 85 06 01 00 00    	jne    80103078 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
80102f72:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80102f79:	66 85 d2             	test   %dx,%dx
80102f7c:	74 22                	je     80102fa0 <mpinit+0xc0>
80102f7e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80102f81:	89 f0                	mov    %esi,%eax
  sum = 0;
80102f83:	31 d2                	xor    %edx,%edx
80102f85:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80102f88:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
80102f8f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80102f92:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80102f94:	39 f8                	cmp    %edi,%eax
80102f96:	75 f0                	jne    80102f88 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80102f98:	84 d2                	test   %dl,%dl
80102f9a:	0f 85 d8 00 00 00    	jne    80103078 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102fa0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102fa6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80102fa9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
80102fac:	a3 20 e6 18 80       	mov    %eax,0x8018e620
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102fb1:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80102fb8:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80102fbe:	01 d7                	add    %edx,%edi
80102fc0:	89 fa                	mov    %edi,%edx
  ismp = 1;
80102fc2:	bf 01 00 00 00       	mov    $0x1,%edi
80102fc7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102fce:	00 
80102fcf:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102fd0:	39 d0                	cmp    %edx,%eax
80102fd2:	73 19                	jae    80102fed <mpinit+0x10d>
    switch(*p){
80102fd4:	0f b6 08             	movzbl (%eax),%ecx
80102fd7:	80 f9 02             	cmp    $0x2,%cl
80102fda:	0f 84 80 00 00 00    	je     80103060 <mpinit+0x180>
80102fe0:	77 6e                	ja     80103050 <mpinit+0x170>
80102fe2:	84 c9                	test   %cl,%cl
80102fe4:	74 3a                	je     80103020 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102fe6:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102fe9:	39 d0                	cmp    %edx,%eax
80102feb:	72 e7                	jb     80102fd4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80102fed:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80102ff0:	85 ff                	test   %edi,%edi
80102ff2:	0f 84 dd 00 00 00    	je     801030d5 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102ff8:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80102ffc:	74 15                	je     80103013 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ffe:	b8 70 00 00 00       	mov    $0x70,%eax
80103003:	ba 22 00 00 00       	mov    $0x22,%edx
80103008:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103009:	ba 23 00 00 00       	mov    $0x23,%edx
8010300e:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010300f:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103012:	ee                   	out    %al,(%dx)
  }
}
80103013:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103016:	5b                   	pop    %ebx
80103017:	5e                   	pop    %esi
80103018:	5f                   	pop    %edi
80103019:	5d                   	pop    %ebp
8010301a:	c3                   	ret
8010301b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
80103020:	8b 0d 24 e7 18 80    	mov    0x8018e724,%ecx
80103026:	83 f9 07             	cmp    $0x7,%ecx
80103029:	7f 19                	jg     80103044 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010302b:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
80103031:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103035:	83 c1 01             	add    $0x1,%ecx
80103038:	89 0d 24 e7 18 80    	mov    %ecx,0x8018e724
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010303e:	88 9e 40 e7 18 80    	mov    %bl,-0x7fe718c0(%esi)
      p += sizeof(struct mpproc);
80103044:	83 c0 14             	add    $0x14,%eax
      continue;
80103047:	eb 87                	jmp    80102fd0 <mpinit+0xf0>
80103049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
80103050:	83 e9 03             	sub    $0x3,%ecx
80103053:	80 f9 01             	cmp    $0x1,%cl
80103056:	76 8e                	jbe    80102fe6 <mpinit+0x106>
80103058:	31 ff                	xor    %edi,%edi
8010305a:	e9 71 ff ff ff       	jmp    80102fd0 <mpinit+0xf0>
8010305f:	90                   	nop
      ioapicid = ioapic->apicno;
80103060:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103064:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103067:	88 0d 20 e7 18 80    	mov    %cl,0x8018e720
      continue;
8010306d:	e9 5e ff ff ff       	jmp    80102fd0 <mpinit+0xf0>
80103072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103078:	83 ec 0c             	sub    $0xc,%esp
8010307b:	68 31 71 10 80       	push   $0x80107131
80103080:	e8 fb d2 ff ff       	call   80100380 <panic>
80103085:	8d 76 00             	lea    0x0(%esi),%esi
{
80103088:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
8010308d:	eb 0b                	jmp    8010309a <mpinit+0x1ba>
8010308f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80103090:	89 f3                	mov    %esi,%ebx
80103092:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103098:	74 de                	je     80103078 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010309a:	83 ec 04             	sub    $0x4,%esp
8010309d:	8d 73 10             	lea    0x10(%ebx),%esi
801030a0:	6a 04                	push   $0x4
801030a2:	68 27 71 10 80       	push   $0x80107127
801030a7:	53                   	push   %ebx
801030a8:	e8 33 13 00 00       	call   801043e0 <memcmp>
801030ad:	83 c4 10             	add    $0x10,%esp
801030b0:	85 c0                	test   %eax,%eax
801030b2:	75 dc                	jne    80103090 <mpinit+0x1b0>
801030b4:	89 da                	mov    %ebx,%edx
801030b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801030bd:	00 
801030be:	66 90                	xchg   %ax,%ax
    sum += addr[i];
801030c0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801030c3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801030c6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801030c8:	39 d6                	cmp    %edx,%esi
801030ca:	75 f4                	jne    801030c0 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801030cc:	84 c0                	test   %al,%al
801030ce:	75 c0                	jne    80103090 <mpinit+0x1b0>
801030d0:	e9 5b fe ff ff       	jmp    80102f30 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801030d5:	83 ec 0c             	sub    $0xc,%esp
801030d8:	68 f8 74 10 80       	push   $0x801074f8
801030dd:	e8 9e d2 ff ff       	call   80100380 <panic>
801030e2:	66 90                	xchg   %ax,%ax
801030e4:	66 90                	xchg   %ax,%ax
801030e6:	66 90                	xchg   %ax,%ax
801030e8:	66 90                	xchg   %ax,%ax
801030ea:	66 90                	xchg   %ax,%ax
801030ec:	66 90                	xchg   %ax,%ax
801030ee:	66 90                	xchg   %ax,%ax

801030f0 <picinit>:
801030f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801030f5:	ba 21 00 00 00       	mov    $0x21,%edx
801030fa:	ee                   	out    %al,(%dx)
801030fb:	ba a1 00 00 00       	mov    $0xa1,%edx
80103100:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103101:	c3                   	ret
80103102:	66 90                	xchg   %ax,%ax
80103104:	66 90                	xchg   %ax,%ax
80103106:	66 90                	xchg   %ax,%ax
80103108:	66 90                	xchg   %ax,%ax
8010310a:	66 90                	xchg   %ax,%ax
8010310c:	66 90                	xchg   %ax,%ax
8010310e:	66 90                	xchg   %ax,%ax

80103110 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103110:	55                   	push   %ebp
80103111:	89 e5                	mov    %esp,%ebp
80103113:	57                   	push   %edi
80103114:	56                   	push   %esi
80103115:	53                   	push   %ebx
80103116:	83 ec 0c             	sub    $0xc,%esp
80103119:	8b 75 08             	mov    0x8(%ebp),%esi
8010311c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010311f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103125:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010312b:	e8 20 dd ff ff       	call   80100e50 <filealloc>
80103130:	89 06                	mov    %eax,(%esi)
80103132:	85 c0                	test   %eax,%eax
80103134:	0f 84 a5 00 00 00    	je     801031df <pipealloc+0xcf>
8010313a:	e8 11 dd ff ff       	call   80100e50 <filealloc>
8010313f:	89 07                	mov    %eax,(%edi)
80103141:	85 c0                	test   %eax,%eax
80103143:	0f 84 84 00 00 00    	je     801031cd <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103149:	e8 12 f2 ff ff       	call   80102360 <kalloc>
8010314e:	89 c3                	mov    %eax,%ebx
80103150:	85 c0                	test   %eax,%eax
80103152:	0f 84 a0 00 00 00    	je     801031f8 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103158:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010315f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103162:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103165:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010316c:	00 00 00 
  p->nwrite = 0;
8010316f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103176:	00 00 00 
  p->nread = 0;
80103179:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103180:	00 00 00 
  initlock(&p->lock, "pipe");
80103183:	68 49 71 10 80       	push   $0x80107149
80103188:	50                   	push   %eax
80103189:	e8 22 0f 00 00       	call   801040b0 <initlock>
  (*f0)->type = FD_PIPE;
8010318e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103190:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103193:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103199:	8b 06                	mov    (%esi),%eax
8010319b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010319f:	8b 06                	mov    (%esi),%eax
801031a1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801031a5:	8b 06                	mov    (%esi),%eax
801031a7:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801031aa:	8b 07                	mov    (%edi),%eax
801031ac:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801031b2:	8b 07                	mov    (%edi),%eax
801031b4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801031b8:	8b 07                	mov    (%edi),%eax
801031ba:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801031be:	8b 07                	mov    (%edi),%eax
801031c0:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
801031c3:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801031c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031c8:	5b                   	pop    %ebx
801031c9:	5e                   	pop    %esi
801031ca:	5f                   	pop    %edi
801031cb:	5d                   	pop    %ebp
801031cc:	c3                   	ret
  if(*f0)
801031cd:	8b 06                	mov    (%esi),%eax
801031cf:	85 c0                	test   %eax,%eax
801031d1:	74 1e                	je     801031f1 <pipealloc+0xe1>
    fileclose(*f0);
801031d3:	83 ec 0c             	sub    $0xc,%esp
801031d6:	50                   	push   %eax
801031d7:	e8 34 dd ff ff       	call   80100f10 <fileclose>
801031dc:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801031df:	8b 07                	mov    (%edi),%eax
801031e1:	85 c0                	test   %eax,%eax
801031e3:	74 0c                	je     801031f1 <pipealloc+0xe1>
    fileclose(*f1);
801031e5:	83 ec 0c             	sub    $0xc,%esp
801031e8:	50                   	push   %eax
801031e9:	e8 22 dd ff ff       	call   80100f10 <fileclose>
801031ee:	83 c4 10             	add    $0x10,%esp
  return -1;
801031f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801031f6:	eb cd                	jmp    801031c5 <pipealloc+0xb5>
  if(*f0)
801031f8:	8b 06                	mov    (%esi),%eax
801031fa:	85 c0                	test   %eax,%eax
801031fc:	75 d5                	jne    801031d3 <pipealloc+0xc3>
801031fe:	eb df                	jmp    801031df <pipealloc+0xcf>

80103200 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103200:	55                   	push   %ebp
80103201:	89 e5                	mov    %esp,%ebp
80103203:	56                   	push   %esi
80103204:	53                   	push   %ebx
80103205:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103208:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010320b:	83 ec 0c             	sub    $0xc,%esp
8010320e:	53                   	push   %ebx
8010320f:	e8 8c 10 00 00       	call   801042a0 <acquire>
  if(writable){
80103214:	83 c4 10             	add    $0x10,%esp
80103217:	85 f6                	test   %esi,%esi
80103219:	74 65                	je     80103280 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010321b:	83 ec 0c             	sub    $0xc,%esp
8010321e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103224:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010322b:	00 00 00 
    wakeup(&p->nread);
8010322e:	50                   	push   %eax
8010322f:	e8 ac 0b 00 00       	call   80103de0 <wakeup>
80103234:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103237:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010323d:	85 d2                	test   %edx,%edx
8010323f:	75 0a                	jne    8010324b <pipeclose+0x4b>
80103241:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103247:	85 c0                	test   %eax,%eax
80103249:	74 15                	je     80103260 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010324b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010324e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103251:	5b                   	pop    %ebx
80103252:	5e                   	pop    %esi
80103253:	5d                   	pop    %ebp
    release(&p->lock);
80103254:	e9 e7 0f 00 00       	jmp    80104240 <release>
80103259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103260:	83 ec 0c             	sub    $0xc,%esp
80103263:	53                   	push   %ebx
80103264:	e8 d7 0f 00 00       	call   80104240 <release>
    kfree((char*)p);
80103269:	83 c4 10             	add    $0x10,%esp
8010326c:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010326f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103272:	5b                   	pop    %ebx
80103273:	5e                   	pop    %esi
80103274:	5d                   	pop    %ebp
    kfree((char*)p);
80103275:	e9 26 ef ff ff       	jmp    801021a0 <kfree>
8010327a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103280:	83 ec 0c             	sub    $0xc,%esp
80103283:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103289:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103290:	00 00 00 
    wakeup(&p->nwrite);
80103293:	50                   	push   %eax
80103294:	e8 47 0b 00 00       	call   80103de0 <wakeup>
80103299:	83 c4 10             	add    $0x10,%esp
8010329c:	eb 99                	jmp    80103237 <pipeclose+0x37>
8010329e:	66 90                	xchg   %ax,%ax

801032a0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801032a0:	55                   	push   %ebp
801032a1:	89 e5                	mov    %esp,%ebp
801032a3:	57                   	push   %edi
801032a4:	56                   	push   %esi
801032a5:	53                   	push   %ebx
801032a6:	83 ec 28             	sub    $0x28,%esp
801032a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032ac:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
801032af:	53                   	push   %ebx
801032b0:	e8 eb 0f 00 00       	call   801042a0 <acquire>
  for(i = 0; i < n; i++){
801032b5:	83 c4 10             	add    $0x10,%esp
801032b8:	85 ff                	test   %edi,%edi
801032ba:	0f 8e ce 00 00 00    	jle    8010338e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801032c0:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801032c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801032c9:	89 7d 10             	mov    %edi,0x10(%ebp)
801032cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801032cf:	8d 34 39             	lea    (%ecx,%edi,1),%esi
801032d2:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801032d5:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801032db:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801032e1:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801032e7:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
801032ed:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
801032f0:	0f 85 b6 00 00 00    	jne    801033ac <pipewrite+0x10c>
801032f6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801032f9:	eb 3b                	jmp    80103336 <pipewrite+0x96>
801032fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103300:	e8 5b 03 00 00       	call   80103660 <myproc>
80103305:	8b 48 24             	mov    0x24(%eax),%ecx
80103308:	85 c9                	test   %ecx,%ecx
8010330a:	75 34                	jne    80103340 <pipewrite+0xa0>
      wakeup(&p->nread);
8010330c:	83 ec 0c             	sub    $0xc,%esp
8010330f:	56                   	push   %esi
80103310:	e8 cb 0a 00 00       	call   80103de0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103315:	58                   	pop    %eax
80103316:	5a                   	pop    %edx
80103317:	53                   	push   %ebx
80103318:	57                   	push   %edi
80103319:	e8 02 0a 00 00       	call   80103d20 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010331e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103324:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010332a:	83 c4 10             	add    $0x10,%esp
8010332d:	05 00 02 00 00       	add    $0x200,%eax
80103332:	39 c2                	cmp    %eax,%edx
80103334:	75 2a                	jne    80103360 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103336:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010333c:	85 c0                	test   %eax,%eax
8010333e:	75 c0                	jne    80103300 <pipewrite+0x60>
        release(&p->lock);
80103340:	83 ec 0c             	sub    $0xc,%esp
80103343:	53                   	push   %ebx
80103344:	e8 f7 0e 00 00       	call   80104240 <release>
        return -1;
80103349:	83 c4 10             	add    $0x10,%esp
8010334c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103351:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103354:	5b                   	pop    %ebx
80103355:	5e                   	pop    %esi
80103356:	5f                   	pop    %edi
80103357:	5d                   	pop    %ebp
80103358:	c3                   	ret
80103359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103360:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103363:	8d 42 01             	lea    0x1(%edx),%eax
80103366:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
8010336c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010336f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103375:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103378:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
8010337c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103380:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103383:	39 c1                	cmp    %eax,%ecx
80103385:	0f 85 50 ff ff ff    	jne    801032db <pipewrite+0x3b>
8010338b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010338e:	83 ec 0c             	sub    $0xc,%esp
80103391:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103397:	50                   	push   %eax
80103398:	e8 43 0a 00 00       	call   80103de0 <wakeup>
  release(&p->lock);
8010339d:	89 1c 24             	mov    %ebx,(%esp)
801033a0:	e8 9b 0e 00 00       	call   80104240 <release>
  return n;
801033a5:	83 c4 10             	add    $0x10,%esp
801033a8:	89 f8                	mov    %edi,%eax
801033aa:	eb a5                	jmp    80103351 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801033af:	eb b2                	jmp    80103363 <pipewrite+0xc3>
801033b1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801033b8:	00 
801033b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801033c0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801033c0:	55                   	push   %ebp
801033c1:	89 e5                	mov    %esp,%ebp
801033c3:	57                   	push   %edi
801033c4:	56                   	push   %esi
801033c5:	53                   	push   %ebx
801033c6:	83 ec 18             	sub    $0x18,%esp
801033c9:	8b 75 08             	mov    0x8(%ebp),%esi
801033cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801033cf:	56                   	push   %esi
801033d0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801033d6:	e8 c5 0e 00 00       	call   801042a0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801033db:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801033e1:	83 c4 10             	add    $0x10,%esp
801033e4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801033ea:	74 2f                	je     8010341b <piperead+0x5b>
801033ec:	eb 37                	jmp    80103425 <piperead+0x65>
801033ee:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801033f0:	e8 6b 02 00 00       	call   80103660 <myproc>
801033f5:	8b 40 24             	mov    0x24(%eax),%eax
801033f8:	85 c0                	test   %eax,%eax
801033fa:	0f 85 80 00 00 00    	jne    80103480 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103400:	83 ec 08             	sub    $0x8,%esp
80103403:	56                   	push   %esi
80103404:	53                   	push   %ebx
80103405:	e8 16 09 00 00       	call   80103d20 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010340a:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103410:	83 c4 10             	add    $0x10,%esp
80103413:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103419:	75 0a                	jne    80103425 <piperead+0x65>
8010341b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103421:	85 d2                	test   %edx,%edx
80103423:	75 cb                	jne    801033f0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103425:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103428:	31 db                	xor    %ebx,%ebx
8010342a:	85 c9                	test   %ecx,%ecx
8010342c:	7f 26                	jg     80103454 <piperead+0x94>
8010342e:	eb 2c                	jmp    8010345c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103430:	8d 48 01             	lea    0x1(%eax),%ecx
80103433:	25 ff 01 00 00       	and    $0x1ff,%eax
80103438:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010343e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103443:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103446:	83 c3 01             	add    $0x1,%ebx
80103449:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010344c:	74 0e                	je     8010345c <piperead+0x9c>
8010344e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80103454:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010345a:	75 d4                	jne    80103430 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010345c:	83 ec 0c             	sub    $0xc,%esp
8010345f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103465:	50                   	push   %eax
80103466:	e8 75 09 00 00       	call   80103de0 <wakeup>
  release(&p->lock);
8010346b:	89 34 24             	mov    %esi,(%esp)
8010346e:	e8 cd 0d 00 00       	call   80104240 <release>
  return i;
80103473:	83 c4 10             	add    $0x10,%esp
}
80103476:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103479:	89 d8                	mov    %ebx,%eax
8010347b:	5b                   	pop    %ebx
8010347c:	5e                   	pop    %esi
8010347d:	5f                   	pop    %edi
8010347e:	5d                   	pop    %ebp
8010347f:	c3                   	ret
      release(&p->lock);
80103480:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103483:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103488:	56                   	push   %esi
80103489:	e8 b2 0d 00 00       	call   80104240 <release>
      return -1;
8010348e:	83 c4 10             	add    $0x10,%esp
}
80103491:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103494:	89 d8                	mov    %ebx,%eax
80103496:	5b                   	pop    %ebx
80103497:	5e                   	pop    %esi
80103498:	5f                   	pop    %edi
80103499:	5d                   	pop    %ebp
8010349a:	c3                   	ret
8010349b:	66 90                	xchg   %ax,%ax
8010349d:	66 90                	xchg   %ax,%ax
8010349f:	90                   	nop

801034a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034a0:	55                   	push   %ebp
801034a1:	89 e5                	mov    %esp,%ebp
801034a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034a4:	bb f4 ec 18 80       	mov    $0x8018ecf4,%ebx
{
801034a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801034ac:	68 c0 ec 18 80       	push   $0x8018ecc0
801034b1:	e8 ea 0d 00 00       	call   801042a0 <acquire>
801034b6:	83 c4 10             	add    $0x10,%esp
801034b9:	eb 10                	jmp    801034cb <allocproc+0x2b>
801034bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034c0:	83 c3 7c             	add    $0x7c,%ebx
801034c3:	81 fb f4 0b 19 80    	cmp    $0x80190bf4,%ebx
801034c9:	74 75                	je     80103540 <allocproc+0xa0>
    if(p->state == UNUSED)
801034cb:	8b 43 0c             	mov    0xc(%ebx),%eax
801034ce:	85 c0                	test   %eax,%eax
801034d0:	75 ee                	jne    801034c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801034d2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801034d7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801034da:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801034e1:	89 43 10             	mov    %eax,0x10(%ebx)
801034e4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801034e7:	68 c0 ec 18 80       	push   $0x8018ecc0
  p->pid = nextpid++;
801034ec:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
801034f2:	e8 49 0d 00 00       	call   80104240 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801034f7:	e8 64 ee ff ff       	call   80102360 <kalloc>
801034fc:	83 c4 10             	add    $0x10,%esp
801034ff:	89 43 08             	mov    %eax,0x8(%ebx)
80103502:	85 c0                	test   %eax,%eax
80103504:	74 53                	je     80103559 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103506:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010350c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010350f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103514:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103517:	c7 40 14 52 55 10 80 	movl   $0x80105552,0x14(%eax)
  p->context = (struct context*)sp;
8010351e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103521:	6a 14                	push   $0x14
80103523:	6a 00                	push   $0x0
80103525:	50                   	push   %eax
80103526:	e8 75 0e 00 00       	call   801043a0 <memset>
  p->context->eip = (uint)forkret;
8010352b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010352e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103531:	c7 40 10 70 35 10 80 	movl   $0x80103570,0x10(%eax)
}
80103538:	89 d8                	mov    %ebx,%eax
8010353a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010353d:	c9                   	leave
8010353e:	c3                   	ret
8010353f:	90                   	nop
  release(&ptable.lock);
80103540:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103543:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103545:	68 c0 ec 18 80       	push   $0x8018ecc0
8010354a:	e8 f1 0c 00 00       	call   80104240 <release>
  return 0;
8010354f:	83 c4 10             	add    $0x10,%esp
}
80103552:	89 d8                	mov    %ebx,%eax
80103554:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103557:	c9                   	leave
80103558:	c3                   	ret
    p->state = UNUSED;
80103559:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80103560:	31 db                	xor    %ebx,%ebx
80103562:	eb ee                	jmp    80103552 <allocproc+0xb2>
80103564:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010356b:	00 
8010356c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103570 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103570:	55                   	push   %ebp
80103571:	89 e5                	mov    %esp,%ebp
80103573:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103576:	68 c0 ec 18 80       	push   $0x8018ecc0
8010357b:	e8 c0 0c 00 00       	call   80104240 <release>

  if (first) {
80103580:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103585:	83 c4 10             	add    $0x10,%esp
80103588:	85 c0                	test   %eax,%eax
8010358a:	75 04                	jne    80103590 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010358c:	c9                   	leave
8010358d:	c3                   	ret
8010358e:	66 90                	xchg   %ax,%ax
    first = 0;
80103590:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103597:	00 00 00 
    iinit(ROOTDEV);
8010359a:	83 ec 0c             	sub    $0xc,%esp
8010359d:	6a 01                	push   $0x1
8010359f:	e8 dc df ff ff       	call   80101580 <iinit>
    initlog(ROOTDEV);
801035a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801035ab:	e8 f0 f3 ff ff       	call   801029a0 <initlog>
}
801035b0:	83 c4 10             	add    $0x10,%esp
801035b3:	c9                   	leave
801035b4:	c3                   	ret
801035b5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801035bc:	00 
801035bd:	8d 76 00             	lea    0x0(%esi),%esi

801035c0 <pinit>:
{
801035c0:	55                   	push   %ebp
801035c1:	89 e5                	mov    %esp,%ebp
801035c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801035c6:	68 4e 71 10 80       	push   $0x8010714e
801035cb:	68 c0 ec 18 80       	push   $0x8018ecc0
801035d0:	e8 db 0a 00 00       	call   801040b0 <initlock>
}
801035d5:	83 c4 10             	add    $0x10,%esp
801035d8:	c9                   	leave
801035d9:	c3                   	ret
801035da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035e0 <mycpu>:
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	56                   	push   %esi
801035e4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801035e5:	9c                   	pushf
801035e6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801035e7:	f6 c4 02             	test   $0x2,%ah
801035ea:	75 46                	jne    80103632 <mycpu+0x52>
  apicid = lapicid();
801035ec:	e8 df ef ff ff       	call   801025d0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801035f1:	8b 35 24 e7 18 80    	mov    0x8018e724,%esi
801035f7:	85 f6                	test   %esi,%esi
801035f9:	7e 2a                	jle    80103625 <mycpu+0x45>
801035fb:	31 d2                	xor    %edx,%edx
801035fd:	eb 08                	jmp    80103607 <mycpu+0x27>
801035ff:	90                   	nop
80103600:	83 c2 01             	add    $0x1,%edx
80103603:	39 f2                	cmp    %esi,%edx
80103605:	74 1e                	je     80103625 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103607:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010360d:	0f b6 99 40 e7 18 80 	movzbl -0x7fe718c0(%ecx),%ebx
80103614:	39 c3                	cmp    %eax,%ebx
80103616:	75 e8                	jne    80103600 <mycpu+0x20>
}
80103618:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010361b:	8d 81 40 e7 18 80    	lea    -0x7fe718c0(%ecx),%eax
}
80103621:	5b                   	pop    %ebx
80103622:	5e                   	pop    %esi
80103623:	5d                   	pop    %ebp
80103624:	c3                   	ret
  panic("unknown apicid\n");
80103625:	83 ec 0c             	sub    $0xc,%esp
80103628:	68 55 71 10 80       	push   $0x80107155
8010362d:	e8 4e cd ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103632:	83 ec 0c             	sub    $0xc,%esp
80103635:	68 18 75 10 80       	push   $0x80107518
8010363a:	e8 41 cd ff ff       	call   80100380 <panic>
8010363f:	90                   	nop

80103640 <cpuid>:
cpuid() {
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103646:	e8 95 ff ff ff       	call   801035e0 <mycpu>
}
8010364b:	c9                   	leave
  return mycpu()-cpus;
8010364c:	2d 40 e7 18 80       	sub    $0x8018e740,%eax
80103651:	c1 f8 04             	sar    $0x4,%eax
80103654:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010365a:	c3                   	ret
8010365b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103660 <myproc>:
myproc(void) {
80103660:	55                   	push   %ebp
80103661:	89 e5                	mov    %esp,%ebp
80103663:	53                   	push   %ebx
80103664:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103667:	e8 e4 0a 00 00       	call   80104150 <pushcli>
  c = mycpu();
8010366c:	e8 6f ff ff ff       	call   801035e0 <mycpu>
  p = c->proc;
80103671:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103677:	e8 24 0b 00 00       	call   801041a0 <popcli>
}
8010367c:	89 d8                	mov    %ebx,%eax
8010367e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103681:	c9                   	leave
80103682:	c3                   	ret
80103683:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010368a:	00 
8010368b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103690 <userinit>:
{
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	53                   	push   %ebx
80103694:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103697:	e8 04 fe ff ff       	call   801034a0 <allocproc>
8010369c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010369e:	a3 f4 0b 19 80       	mov    %eax,0x80190bf4
  if((p->pgdir = setupkvm()) == 0)
801036a3:	e8 78 34 00 00       	call   80106b20 <setupkvm>
801036a8:	89 43 04             	mov    %eax,0x4(%ebx)
801036ab:	85 c0                	test   %eax,%eax
801036ad:	0f 84 bd 00 00 00    	je     80103770 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801036b3:	83 ec 04             	sub    $0x4,%esp
801036b6:	68 2c 00 00 00       	push   $0x2c
801036bb:	68 60 a4 10 80       	push   $0x8010a460
801036c0:	50                   	push   %eax
801036c1:	e8 3a 31 00 00       	call   80106800 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801036c6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801036c9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801036cf:	6a 4c                	push   $0x4c
801036d1:	6a 00                	push   $0x0
801036d3:	ff 73 18             	push   0x18(%ebx)
801036d6:	e8 c5 0c 00 00       	call   801043a0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801036db:	8b 43 18             	mov    0x18(%ebx),%eax
801036de:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801036e3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801036e6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801036eb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801036ef:	8b 43 18             	mov    0x18(%ebx),%eax
801036f2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801036f6:	8b 43 18             	mov    0x18(%ebx),%eax
801036f9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801036fd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103701:	8b 43 18             	mov    0x18(%ebx),%eax
80103704:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103708:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010370c:	8b 43 18             	mov    0x18(%ebx),%eax
8010370f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103716:	8b 43 18             	mov    0x18(%ebx),%eax
80103719:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103720:	8b 43 18             	mov    0x18(%ebx),%eax
80103723:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010372a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010372d:	6a 10                	push   $0x10
8010372f:	68 7e 71 10 80       	push   $0x8010717e
80103734:	50                   	push   %eax
80103735:	e8 16 0e 00 00       	call   80104550 <safestrcpy>
  p->cwd = namei("/");
8010373a:	c7 04 24 87 71 10 80 	movl   $0x80107187,(%esp)
80103741:	e8 3a e9 ff ff       	call   80102080 <namei>
80103746:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103749:	c7 04 24 c0 ec 18 80 	movl   $0x8018ecc0,(%esp)
80103750:	e8 4b 0b 00 00       	call   801042a0 <acquire>
  p->state = RUNNABLE;
80103755:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010375c:	c7 04 24 c0 ec 18 80 	movl   $0x8018ecc0,(%esp)
80103763:	e8 d8 0a 00 00       	call   80104240 <release>
}
80103768:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010376b:	83 c4 10             	add    $0x10,%esp
8010376e:	c9                   	leave
8010376f:	c3                   	ret
    panic("userinit: out of memory?");
80103770:	83 ec 0c             	sub    $0xc,%esp
80103773:	68 65 71 10 80       	push   $0x80107165
80103778:	e8 03 cc ff ff       	call   80100380 <panic>
8010377d:	8d 76 00             	lea    0x0(%esi),%esi

80103780 <growproc>:
{
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	56                   	push   %esi
80103784:	53                   	push   %ebx
80103785:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103788:	e8 c3 09 00 00       	call   80104150 <pushcli>
  c = mycpu();
8010378d:	e8 4e fe ff ff       	call   801035e0 <mycpu>
  p = c->proc;
80103792:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103798:	e8 03 0a 00 00       	call   801041a0 <popcli>
  sz = curproc->sz;
8010379d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
8010379f:	85 f6                	test   %esi,%esi
801037a1:	7f 1d                	jg     801037c0 <growproc+0x40>
  } else if(n < 0){
801037a3:	75 3b                	jne    801037e0 <growproc+0x60>
  switchuvm(curproc);
801037a5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801037a8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801037aa:	53                   	push   %ebx
801037ab:	e8 40 2f 00 00       	call   801066f0 <switchuvm>
  return 0;
801037b0:	83 c4 10             	add    $0x10,%esp
801037b3:	31 c0                	xor    %eax,%eax
}
801037b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037b8:	5b                   	pop    %ebx
801037b9:	5e                   	pop    %esi
801037ba:	5d                   	pop    %ebp
801037bb:	c3                   	ret
801037bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801037c0:	83 ec 04             	sub    $0x4,%esp
801037c3:	01 c6                	add    %eax,%esi
801037c5:	56                   	push   %esi
801037c6:	50                   	push   %eax
801037c7:	ff 73 04             	push   0x4(%ebx)
801037ca:	e8 81 31 00 00       	call   80106950 <allocuvm>
801037cf:	83 c4 10             	add    $0x10,%esp
801037d2:	85 c0                	test   %eax,%eax
801037d4:	75 cf                	jne    801037a5 <growproc+0x25>
      return -1;
801037d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801037db:	eb d8                	jmp    801037b5 <growproc+0x35>
801037dd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801037e0:	83 ec 04             	sub    $0x4,%esp
801037e3:	01 c6                	add    %eax,%esi
801037e5:	56                   	push   %esi
801037e6:	50                   	push   %eax
801037e7:	ff 73 04             	push   0x4(%ebx)
801037ea:	e8 81 32 00 00       	call   80106a70 <deallocuvm>
801037ef:	83 c4 10             	add    $0x10,%esp
801037f2:	85 c0                	test   %eax,%eax
801037f4:	75 af                	jne    801037a5 <growproc+0x25>
801037f6:	eb de                	jmp    801037d6 <growproc+0x56>
801037f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801037ff:	00 

80103800 <fork>:
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	57                   	push   %edi
80103804:	56                   	push   %esi
80103805:	53                   	push   %ebx
80103806:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103809:	e8 42 09 00 00       	call   80104150 <pushcli>
  c = mycpu();
8010380e:	e8 cd fd ff ff       	call   801035e0 <mycpu>
  p = c->proc;
80103813:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103819:	e8 82 09 00 00       	call   801041a0 <popcli>
  if((np = allocproc()) == 0){
8010381e:	e8 7d fc ff ff       	call   801034a0 <allocproc>
80103823:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103826:	85 c0                	test   %eax,%eax
80103828:	0f 84 d6 00 00 00    	je     80103904 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
8010382e:	83 ec 08             	sub    $0x8,%esp
80103831:	ff 33                	push   (%ebx)
80103833:	89 c7                	mov    %eax,%edi
80103835:	ff 73 04             	push   0x4(%ebx)
80103838:	e8 d3 33 00 00       	call   80106c10 <copyuvm>
8010383d:	83 c4 10             	add    $0x10,%esp
80103840:	89 47 04             	mov    %eax,0x4(%edi)
80103843:	85 c0                	test   %eax,%eax
80103845:	0f 84 9a 00 00 00    	je     801038e5 <fork+0xe5>
  np->sz = curproc->sz;
8010384b:	8b 03                	mov    (%ebx),%eax
8010384d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103850:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103852:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103855:	89 c8                	mov    %ecx,%eax
80103857:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010385a:	b9 13 00 00 00       	mov    $0x13,%ecx
8010385f:	8b 73 18             	mov    0x18(%ebx),%esi
80103862:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103864:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103866:	8b 40 18             	mov    0x18(%eax),%eax
80103869:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103870:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103874:	85 c0                	test   %eax,%eax
80103876:	74 13                	je     8010388b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103878:	83 ec 0c             	sub    $0xc,%esp
8010387b:	50                   	push   %eax
8010387c:	e8 3f d6 ff ff       	call   80100ec0 <filedup>
80103881:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103884:	83 c4 10             	add    $0x10,%esp
80103887:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010388b:	83 c6 01             	add    $0x1,%esi
8010388e:	83 fe 10             	cmp    $0x10,%esi
80103891:	75 dd                	jne    80103870 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103893:	83 ec 0c             	sub    $0xc,%esp
80103896:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103899:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010389c:	e8 cf de ff ff       	call   80101770 <idup>
801038a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801038a4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
801038a7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801038aa:	8d 47 6c             	lea    0x6c(%edi),%eax
801038ad:	6a 10                	push   $0x10
801038af:	53                   	push   %ebx
801038b0:	50                   	push   %eax
801038b1:	e8 9a 0c 00 00       	call   80104550 <safestrcpy>
  pid = np->pid;
801038b6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801038b9:	c7 04 24 c0 ec 18 80 	movl   $0x8018ecc0,(%esp)
801038c0:	e8 db 09 00 00       	call   801042a0 <acquire>
  np->state = RUNNABLE;
801038c5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801038cc:	c7 04 24 c0 ec 18 80 	movl   $0x8018ecc0,(%esp)
801038d3:	e8 68 09 00 00       	call   80104240 <release>
  return pid;
801038d8:	83 c4 10             	add    $0x10,%esp
}
801038db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038de:	89 d8                	mov    %ebx,%eax
801038e0:	5b                   	pop    %ebx
801038e1:	5e                   	pop    %esi
801038e2:	5f                   	pop    %edi
801038e3:	5d                   	pop    %ebp
801038e4:	c3                   	ret
    kfree(np->kstack);
801038e5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801038e8:	83 ec 0c             	sub    $0xc,%esp
801038eb:	ff 73 08             	push   0x8(%ebx)
801038ee:	e8 ad e8 ff ff       	call   801021a0 <kfree>
    np->kstack = 0;
801038f3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
801038fa:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801038fd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103904:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103909:	eb d0                	jmp    801038db <fork+0xdb>
8010390b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103910 <scheduler>:
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	57                   	push   %edi
80103914:	56                   	push   %esi
80103915:	53                   	push   %ebx
80103916:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103919:	e8 c2 fc ff ff       	call   801035e0 <mycpu>
  c->proc = 0;
8010391e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103925:	00 00 00 
  struct cpu *c = mycpu();
80103928:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010392a:	8d 78 04             	lea    0x4(%eax),%edi
8010392d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103930:	fb                   	sti
    acquire(&ptable.lock);
80103931:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103934:	bb f4 ec 18 80       	mov    $0x8018ecf4,%ebx
    acquire(&ptable.lock);
80103939:	68 c0 ec 18 80       	push   $0x8018ecc0
8010393e:	e8 5d 09 00 00       	call   801042a0 <acquire>
80103943:	83 c4 10             	add    $0x10,%esp
80103946:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010394d:	00 
8010394e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103950:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103954:	75 33                	jne    80103989 <scheduler+0x79>
      switchuvm(p);
80103956:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103959:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010395f:	53                   	push   %ebx
80103960:	e8 8b 2d 00 00       	call   801066f0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103965:	58                   	pop    %eax
80103966:	5a                   	pop    %edx
80103967:	ff 73 1c             	push   0x1c(%ebx)
8010396a:	57                   	push   %edi
      p->state = RUNNING;
8010396b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103972:	e8 34 0c 00 00       	call   801045ab <swtch>
      switchkvm();
80103977:	e8 64 2d 00 00       	call   801066e0 <switchkvm>
      c->proc = 0;
8010397c:	83 c4 10             	add    $0x10,%esp
8010397f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103986:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103989:	83 c3 7c             	add    $0x7c,%ebx
8010398c:	81 fb f4 0b 19 80    	cmp    $0x80190bf4,%ebx
80103992:	75 bc                	jne    80103950 <scheduler+0x40>
    release(&ptable.lock);
80103994:	83 ec 0c             	sub    $0xc,%esp
80103997:	68 c0 ec 18 80       	push   $0x8018ecc0
8010399c:	e8 9f 08 00 00       	call   80104240 <release>
    sti();
801039a1:	83 c4 10             	add    $0x10,%esp
801039a4:	eb 8a                	jmp    80103930 <scheduler+0x20>
801039a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801039ad:	00 
801039ae:	66 90                	xchg   %ax,%ax

801039b0 <sched>:
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	56                   	push   %esi
801039b4:	53                   	push   %ebx
  pushcli();
801039b5:	e8 96 07 00 00       	call   80104150 <pushcli>
  c = mycpu();
801039ba:	e8 21 fc ff ff       	call   801035e0 <mycpu>
  p = c->proc;
801039bf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039c5:	e8 d6 07 00 00       	call   801041a0 <popcli>
  if(!holding(&ptable.lock))
801039ca:	83 ec 0c             	sub    $0xc,%esp
801039cd:	68 c0 ec 18 80       	push   $0x8018ecc0
801039d2:	e8 29 08 00 00       	call   80104200 <holding>
801039d7:	83 c4 10             	add    $0x10,%esp
801039da:	85 c0                	test   %eax,%eax
801039dc:	74 4f                	je     80103a2d <sched+0x7d>
  if(mycpu()->ncli != 1)
801039de:	e8 fd fb ff ff       	call   801035e0 <mycpu>
801039e3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801039ea:	75 68                	jne    80103a54 <sched+0xa4>
  if(p->state == RUNNING)
801039ec:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801039f0:	74 55                	je     80103a47 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801039f2:	9c                   	pushf
801039f3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801039f4:	f6 c4 02             	test   $0x2,%ah
801039f7:	75 41                	jne    80103a3a <sched+0x8a>
  intena = mycpu()->intena;
801039f9:	e8 e2 fb ff ff       	call   801035e0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801039fe:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103a01:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103a07:	e8 d4 fb ff ff       	call   801035e0 <mycpu>
80103a0c:	83 ec 08             	sub    $0x8,%esp
80103a0f:	ff 70 04             	push   0x4(%eax)
80103a12:	53                   	push   %ebx
80103a13:	e8 93 0b 00 00       	call   801045ab <swtch>
  mycpu()->intena = intena;
80103a18:	e8 c3 fb ff ff       	call   801035e0 <mycpu>
}
80103a1d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103a20:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103a26:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a29:	5b                   	pop    %ebx
80103a2a:	5e                   	pop    %esi
80103a2b:	5d                   	pop    %ebp
80103a2c:	c3                   	ret
    panic("sched ptable.lock");
80103a2d:	83 ec 0c             	sub    $0xc,%esp
80103a30:	68 89 71 10 80       	push   $0x80107189
80103a35:	e8 46 c9 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103a3a:	83 ec 0c             	sub    $0xc,%esp
80103a3d:	68 b5 71 10 80       	push   $0x801071b5
80103a42:	e8 39 c9 ff ff       	call   80100380 <panic>
    panic("sched running");
80103a47:	83 ec 0c             	sub    $0xc,%esp
80103a4a:	68 a7 71 10 80       	push   $0x801071a7
80103a4f:	e8 2c c9 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103a54:	83 ec 0c             	sub    $0xc,%esp
80103a57:	68 9b 71 10 80       	push   $0x8010719b
80103a5c:	e8 1f c9 ff ff       	call   80100380 <panic>
80103a61:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103a68:	00 
80103a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a70 <exit>:
{
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	57                   	push   %edi
80103a74:	56                   	push   %esi
80103a75:	53                   	push   %ebx
80103a76:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103a79:	e8 e2 fb ff ff       	call   80103660 <myproc>
  if(curproc == initproc)
80103a7e:	39 05 f4 0b 19 80    	cmp    %eax,0x80190bf4
80103a84:	0f 84 fd 00 00 00    	je     80103b87 <exit+0x117>
80103a8a:	89 c3                	mov    %eax,%ebx
80103a8c:	8d 70 28             	lea    0x28(%eax),%esi
80103a8f:	8d 78 68             	lea    0x68(%eax),%edi
80103a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103a98:	8b 06                	mov    (%esi),%eax
80103a9a:	85 c0                	test   %eax,%eax
80103a9c:	74 12                	je     80103ab0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103a9e:	83 ec 0c             	sub    $0xc,%esp
80103aa1:	50                   	push   %eax
80103aa2:	e8 69 d4 ff ff       	call   80100f10 <fileclose>
      curproc->ofile[fd] = 0;
80103aa7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103aad:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103ab0:	83 c6 04             	add    $0x4,%esi
80103ab3:	39 f7                	cmp    %esi,%edi
80103ab5:	75 e1                	jne    80103a98 <exit+0x28>
  begin_op();
80103ab7:	e8 84 ef ff ff       	call   80102a40 <begin_op>
  iput(curproc->cwd);
80103abc:	83 ec 0c             	sub    $0xc,%esp
80103abf:	ff 73 68             	push   0x68(%ebx)
80103ac2:	e8 09 de ff ff       	call   801018d0 <iput>
  end_op();
80103ac7:	e8 e4 ef ff ff       	call   80102ab0 <end_op>
  curproc->cwd = 0;
80103acc:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103ad3:	c7 04 24 c0 ec 18 80 	movl   $0x8018ecc0,(%esp)
80103ada:	e8 c1 07 00 00       	call   801042a0 <acquire>
  wakeup1(curproc->parent);
80103adf:	8b 53 14             	mov    0x14(%ebx),%edx
80103ae2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ae5:	b8 f4 ec 18 80       	mov    $0x8018ecf4,%eax
80103aea:	eb 0e                	jmp    80103afa <exit+0x8a>
80103aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103af0:	83 c0 7c             	add    $0x7c,%eax
80103af3:	3d f4 0b 19 80       	cmp    $0x80190bf4,%eax
80103af8:	74 1c                	je     80103b16 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103afa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103afe:	75 f0                	jne    80103af0 <exit+0x80>
80103b00:	3b 50 20             	cmp    0x20(%eax),%edx
80103b03:	75 eb                	jne    80103af0 <exit+0x80>
      p->state = RUNNABLE;
80103b05:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b0c:	83 c0 7c             	add    $0x7c,%eax
80103b0f:	3d f4 0b 19 80       	cmp    $0x80190bf4,%eax
80103b14:	75 e4                	jne    80103afa <exit+0x8a>
      p->parent = initproc;
80103b16:	8b 0d f4 0b 19 80    	mov    0x80190bf4,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b1c:	ba f4 ec 18 80       	mov    $0x8018ecf4,%edx
80103b21:	eb 10                	jmp    80103b33 <exit+0xc3>
80103b23:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b28:	83 c2 7c             	add    $0x7c,%edx
80103b2b:	81 fa f4 0b 19 80    	cmp    $0x80190bf4,%edx
80103b31:	74 3b                	je     80103b6e <exit+0xfe>
    if(p->parent == curproc){
80103b33:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103b36:	75 f0                	jne    80103b28 <exit+0xb8>
      if(p->state == ZOMBIE)
80103b38:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103b3c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103b3f:	75 e7                	jne    80103b28 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b41:	b8 f4 ec 18 80       	mov    $0x8018ecf4,%eax
80103b46:	eb 12                	jmp    80103b5a <exit+0xea>
80103b48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b4f:	00 
80103b50:	83 c0 7c             	add    $0x7c,%eax
80103b53:	3d f4 0b 19 80       	cmp    $0x80190bf4,%eax
80103b58:	74 ce                	je     80103b28 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103b5a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103b5e:	75 f0                	jne    80103b50 <exit+0xe0>
80103b60:	3b 48 20             	cmp    0x20(%eax),%ecx
80103b63:	75 eb                	jne    80103b50 <exit+0xe0>
      p->state = RUNNABLE;
80103b65:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103b6c:	eb e2                	jmp    80103b50 <exit+0xe0>
  curproc->state = ZOMBIE;
80103b6e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103b75:	e8 36 fe ff ff       	call   801039b0 <sched>
  panic("zombie exit");
80103b7a:	83 ec 0c             	sub    $0xc,%esp
80103b7d:	68 d6 71 10 80       	push   $0x801071d6
80103b82:	e8 f9 c7 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103b87:	83 ec 0c             	sub    $0xc,%esp
80103b8a:	68 c9 71 10 80       	push   $0x801071c9
80103b8f:	e8 ec c7 ff ff       	call   80100380 <panic>
80103b94:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b9b:	00 
80103b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ba0 <wait>:
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	56                   	push   %esi
80103ba4:	53                   	push   %ebx
  pushcli();
80103ba5:	e8 a6 05 00 00       	call   80104150 <pushcli>
  c = mycpu();
80103baa:	e8 31 fa ff ff       	call   801035e0 <mycpu>
  p = c->proc;
80103baf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103bb5:	e8 e6 05 00 00       	call   801041a0 <popcli>
  acquire(&ptable.lock);
80103bba:	83 ec 0c             	sub    $0xc,%esp
80103bbd:	68 c0 ec 18 80       	push   $0x8018ecc0
80103bc2:	e8 d9 06 00 00       	call   801042a0 <acquire>
80103bc7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103bca:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bcc:	bb f4 ec 18 80       	mov    $0x8018ecf4,%ebx
80103bd1:	eb 10                	jmp    80103be3 <wait+0x43>
80103bd3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103bd8:	83 c3 7c             	add    $0x7c,%ebx
80103bdb:	81 fb f4 0b 19 80    	cmp    $0x80190bf4,%ebx
80103be1:	74 1b                	je     80103bfe <wait+0x5e>
      if(p->parent != curproc)
80103be3:	39 73 14             	cmp    %esi,0x14(%ebx)
80103be6:	75 f0                	jne    80103bd8 <wait+0x38>
      if(p->state == ZOMBIE){
80103be8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103bec:	74 62                	je     80103c50 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bee:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103bf1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bf6:	81 fb f4 0b 19 80    	cmp    $0x80190bf4,%ebx
80103bfc:	75 e5                	jne    80103be3 <wait+0x43>
    if(!havekids || curproc->killed){
80103bfe:	85 c0                	test   %eax,%eax
80103c00:	0f 84 a0 00 00 00    	je     80103ca6 <wait+0x106>
80103c06:	8b 46 24             	mov    0x24(%esi),%eax
80103c09:	85 c0                	test   %eax,%eax
80103c0b:	0f 85 95 00 00 00    	jne    80103ca6 <wait+0x106>
  pushcli();
80103c11:	e8 3a 05 00 00       	call   80104150 <pushcli>
  c = mycpu();
80103c16:	e8 c5 f9 ff ff       	call   801035e0 <mycpu>
  p = c->proc;
80103c1b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c21:	e8 7a 05 00 00       	call   801041a0 <popcli>
  if(p == 0)
80103c26:	85 db                	test   %ebx,%ebx
80103c28:	0f 84 8f 00 00 00    	je     80103cbd <wait+0x11d>
  p->chan = chan;
80103c2e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80103c31:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103c38:	e8 73 fd ff ff       	call   801039b0 <sched>
  p->chan = 0;
80103c3d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103c44:	eb 84                	jmp    80103bca <wait+0x2a>
80103c46:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103c4d:	00 
80103c4e:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
80103c50:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80103c53:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103c56:	ff 73 08             	push   0x8(%ebx)
80103c59:	e8 42 e5 ff ff       	call   801021a0 <kfree>
        p->kstack = 0;
80103c5e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103c65:	5a                   	pop    %edx
80103c66:	ff 73 04             	push   0x4(%ebx)
80103c69:	e8 32 2e 00 00       	call   80106aa0 <freevm>
        p->pid = 0;
80103c6e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103c75:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103c7c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103c80:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103c87:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103c8e:	c7 04 24 c0 ec 18 80 	movl   $0x8018ecc0,(%esp)
80103c95:	e8 a6 05 00 00       	call   80104240 <release>
        return pid;
80103c9a:	83 c4 10             	add    $0x10,%esp
}
80103c9d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ca0:	89 f0                	mov    %esi,%eax
80103ca2:	5b                   	pop    %ebx
80103ca3:	5e                   	pop    %esi
80103ca4:	5d                   	pop    %ebp
80103ca5:	c3                   	ret
      release(&ptable.lock);
80103ca6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103ca9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103cae:	68 c0 ec 18 80       	push   $0x8018ecc0
80103cb3:	e8 88 05 00 00       	call   80104240 <release>
      return -1;
80103cb8:	83 c4 10             	add    $0x10,%esp
80103cbb:	eb e0                	jmp    80103c9d <wait+0xfd>
    panic("sleep");
80103cbd:	83 ec 0c             	sub    $0xc,%esp
80103cc0:	68 e2 71 10 80       	push   $0x801071e2
80103cc5:	e8 b6 c6 ff ff       	call   80100380 <panic>
80103cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103cd0 <yield>:
{
80103cd0:	55                   	push   %ebp
80103cd1:	89 e5                	mov    %esp,%ebp
80103cd3:	53                   	push   %ebx
80103cd4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103cd7:	68 c0 ec 18 80       	push   $0x8018ecc0
80103cdc:	e8 bf 05 00 00       	call   801042a0 <acquire>
  pushcli();
80103ce1:	e8 6a 04 00 00       	call   80104150 <pushcli>
  c = mycpu();
80103ce6:	e8 f5 f8 ff ff       	call   801035e0 <mycpu>
  p = c->proc;
80103ceb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cf1:	e8 aa 04 00 00       	call   801041a0 <popcli>
  myproc()->state = RUNNABLE;
80103cf6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103cfd:	e8 ae fc ff ff       	call   801039b0 <sched>
  release(&ptable.lock);
80103d02:	c7 04 24 c0 ec 18 80 	movl   $0x8018ecc0,(%esp)
80103d09:	e8 32 05 00 00       	call   80104240 <release>
}
80103d0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d11:	83 c4 10             	add    $0x10,%esp
80103d14:	c9                   	leave
80103d15:	c3                   	ret
80103d16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103d1d:	00 
80103d1e:	66 90                	xchg   %ax,%ax

80103d20 <sleep>:
{
80103d20:	55                   	push   %ebp
80103d21:	89 e5                	mov    %esp,%ebp
80103d23:	57                   	push   %edi
80103d24:	56                   	push   %esi
80103d25:	53                   	push   %ebx
80103d26:	83 ec 0c             	sub    $0xc,%esp
80103d29:	8b 7d 08             	mov    0x8(%ebp),%edi
80103d2c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103d2f:	e8 1c 04 00 00       	call   80104150 <pushcli>
  c = mycpu();
80103d34:	e8 a7 f8 ff ff       	call   801035e0 <mycpu>
  p = c->proc;
80103d39:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d3f:	e8 5c 04 00 00       	call   801041a0 <popcli>
  if(p == 0)
80103d44:	85 db                	test   %ebx,%ebx
80103d46:	0f 84 87 00 00 00    	je     80103dd3 <sleep+0xb3>
  if(lk == 0)
80103d4c:	85 f6                	test   %esi,%esi
80103d4e:	74 76                	je     80103dc6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103d50:	81 fe c0 ec 18 80    	cmp    $0x8018ecc0,%esi
80103d56:	74 50                	je     80103da8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103d58:	83 ec 0c             	sub    $0xc,%esp
80103d5b:	68 c0 ec 18 80       	push   $0x8018ecc0
80103d60:	e8 3b 05 00 00       	call   801042a0 <acquire>
    release(lk);
80103d65:	89 34 24             	mov    %esi,(%esp)
80103d68:	e8 d3 04 00 00       	call   80104240 <release>
  p->chan = chan;
80103d6d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103d70:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103d77:	e8 34 fc ff ff       	call   801039b0 <sched>
  p->chan = 0;
80103d7c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103d83:	c7 04 24 c0 ec 18 80 	movl   $0x8018ecc0,(%esp)
80103d8a:	e8 b1 04 00 00       	call   80104240 <release>
    acquire(lk);
80103d8f:	83 c4 10             	add    $0x10,%esp
80103d92:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103d95:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d98:	5b                   	pop    %ebx
80103d99:	5e                   	pop    %esi
80103d9a:	5f                   	pop    %edi
80103d9b:	5d                   	pop    %ebp
    acquire(lk);
80103d9c:	e9 ff 04 00 00       	jmp    801042a0 <acquire>
80103da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103da8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103dab:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103db2:	e8 f9 fb ff ff       	call   801039b0 <sched>
  p->chan = 0;
80103db7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103dbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dc1:	5b                   	pop    %ebx
80103dc2:	5e                   	pop    %esi
80103dc3:	5f                   	pop    %edi
80103dc4:	5d                   	pop    %ebp
80103dc5:	c3                   	ret
    panic("sleep without lk");
80103dc6:	83 ec 0c             	sub    $0xc,%esp
80103dc9:	68 e8 71 10 80       	push   $0x801071e8
80103dce:	e8 ad c5 ff ff       	call   80100380 <panic>
    panic("sleep");
80103dd3:	83 ec 0c             	sub    $0xc,%esp
80103dd6:	68 e2 71 10 80       	push   $0x801071e2
80103ddb:	e8 a0 c5 ff ff       	call   80100380 <panic>

80103de0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	53                   	push   %ebx
80103de4:	83 ec 10             	sub    $0x10,%esp
80103de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103dea:	68 c0 ec 18 80       	push   $0x8018ecc0
80103def:	e8 ac 04 00 00       	call   801042a0 <acquire>
80103df4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103df7:	b8 f4 ec 18 80       	mov    $0x8018ecf4,%eax
80103dfc:	eb 0c                	jmp    80103e0a <wakeup+0x2a>
80103dfe:	66 90                	xchg   %ax,%ax
80103e00:	83 c0 7c             	add    $0x7c,%eax
80103e03:	3d f4 0b 19 80       	cmp    $0x80190bf4,%eax
80103e08:	74 1c                	je     80103e26 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
80103e0a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e0e:	75 f0                	jne    80103e00 <wakeup+0x20>
80103e10:	3b 58 20             	cmp    0x20(%eax),%ebx
80103e13:	75 eb                	jne    80103e00 <wakeup+0x20>
      p->state = RUNNABLE;
80103e15:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e1c:	83 c0 7c             	add    $0x7c,%eax
80103e1f:	3d f4 0b 19 80       	cmp    $0x80190bf4,%eax
80103e24:	75 e4                	jne    80103e0a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80103e26:	c7 45 08 c0 ec 18 80 	movl   $0x8018ecc0,0x8(%ebp)
}
80103e2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e30:	c9                   	leave
  release(&ptable.lock);
80103e31:	e9 0a 04 00 00       	jmp    80104240 <release>
80103e36:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e3d:	00 
80103e3e:	66 90                	xchg   %ax,%ax

80103e40 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	53                   	push   %ebx
80103e44:	83 ec 10             	sub    $0x10,%esp
80103e47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103e4a:	68 c0 ec 18 80       	push   $0x8018ecc0
80103e4f:	e8 4c 04 00 00       	call   801042a0 <acquire>
80103e54:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e57:	b8 f4 ec 18 80       	mov    $0x8018ecf4,%eax
80103e5c:	eb 0c                	jmp    80103e6a <kill+0x2a>
80103e5e:	66 90                	xchg   %ax,%ax
80103e60:	83 c0 7c             	add    $0x7c,%eax
80103e63:	3d f4 0b 19 80       	cmp    $0x80190bf4,%eax
80103e68:	74 36                	je     80103ea0 <kill+0x60>
    if(p->pid == pid){
80103e6a:	39 58 10             	cmp    %ebx,0x10(%eax)
80103e6d:	75 f1                	jne    80103e60 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103e6f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80103e73:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80103e7a:	75 07                	jne    80103e83 <kill+0x43>
        p->state = RUNNABLE;
80103e7c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80103e83:	83 ec 0c             	sub    $0xc,%esp
80103e86:	68 c0 ec 18 80       	push   $0x8018ecc0
80103e8b:	e8 b0 03 00 00       	call   80104240 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103e90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80103e93:	83 c4 10             	add    $0x10,%esp
80103e96:	31 c0                	xor    %eax,%eax
}
80103e98:	c9                   	leave
80103e99:	c3                   	ret
80103e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103ea0:	83 ec 0c             	sub    $0xc,%esp
80103ea3:	68 c0 ec 18 80       	push   $0x8018ecc0
80103ea8:	e8 93 03 00 00       	call   80104240 <release>
}
80103ead:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80103eb0:	83 c4 10             	add    $0x10,%esp
80103eb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103eb8:	c9                   	leave
80103eb9:	c3                   	ret
80103eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ec0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	57                   	push   %edi
80103ec4:	56                   	push   %esi
80103ec5:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103ec8:	53                   	push   %ebx
80103ec9:	bb 60 ed 18 80       	mov    $0x8018ed60,%ebx
80103ece:	83 ec 3c             	sub    $0x3c,%esp
80103ed1:	eb 24                	jmp    80103ef7 <procdump+0x37>
80103ed3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103ed8:	83 ec 0c             	sub    $0xc,%esp
80103edb:	68 a7 73 10 80       	push   $0x801073a7
80103ee0:	e8 cb c7 ff ff       	call   801006b0 <cprintf>
80103ee5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ee8:	83 c3 7c             	add    $0x7c,%ebx
80103eeb:	81 fb 60 0c 19 80    	cmp    $0x80190c60,%ebx
80103ef1:	0f 84 81 00 00 00    	je     80103f78 <procdump+0xb8>
    if(p->state == UNUSED)
80103ef7:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103efa:	85 c0                	test   %eax,%eax
80103efc:	74 ea                	je     80103ee8 <procdump+0x28>
      state = "???";
80103efe:	ba f9 71 10 80       	mov    $0x801071f9,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103f03:	83 f8 05             	cmp    $0x5,%eax
80103f06:	77 11                	ja     80103f19 <procdump+0x59>
80103f08:	8b 14 85 20 78 10 80 	mov    -0x7fef87e0(,%eax,4),%edx
      state = "???";
80103f0f:	b8 f9 71 10 80       	mov    $0x801071f9,%eax
80103f14:	85 d2                	test   %edx,%edx
80103f16:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103f19:	53                   	push   %ebx
80103f1a:	52                   	push   %edx
80103f1b:	ff 73 a4             	push   -0x5c(%ebx)
80103f1e:	68 fd 71 10 80       	push   $0x801071fd
80103f23:	e8 88 c7 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80103f28:	83 c4 10             	add    $0x10,%esp
80103f2b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103f2f:	75 a7                	jne    80103ed8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103f31:	83 ec 08             	sub    $0x8,%esp
80103f34:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103f37:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103f3a:	50                   	push   %eax
80103f3b:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103f3e:	8b 40 0c             	mov    0xc(%eax),%eax
80103f41:	83 c0 08             	add    $0x8,%eax
80103f44:	50                   	push   %eax
80103f45:	e8 86 01 00 00       	call   801040d0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80103f4a:	83 c4 10             	add    $0x10,%esp
80103f4d:	8d 76 00             	lea    0x0(%esi),%esi
80103f50:	8b 17                	mov    (%edi),%edx
80103f52:	85 d2                	test   %edx,%edx
80103f54:	74 82                	je     80103ed8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80103f56:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80103f59:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
80103f5c:	52                   	push   %edx
80103f5d:	68 a1 6f 10 80       	push   $0x80106fa1
80103f62:	e8 49 c7 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103f67:	83 c4 10             	add    $0x10,%esp
80103f6a:	39 f7                	cmp    %esi,%edi
80103f6c:	75 e2                	jne    80103f50 <procdump+0x90>
80103f6e:	e9 65 ff ff ff       	jmp    80103ed8 <procdump+0x18>
80103f73:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
80103f78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f7b:	5b                   	pop    %ebx
80103f7c:	5e                   	pop    %esi
80103f7d:	5f                   	pop    %edi
80103f7e:	5d                   	pop    %ebp
80103f7f:	c3                   	ret

80103f80 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103f80:	55                   	push   %ebp
80103f81:	89 e5                	mov    %esp,%ebp
80103f83:	53                   	push   %ebx
80103f84:	83 ec 0c             	sub    $0xc,%esp
80103f87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103f8a:	68 30 72 10 80       	push   $0x80107230
80103f8f:	8d 43 04             	lea    0x4(%ebx),%eax
80103f92:	50                   	push   %eax
80103f93:	e8 18 01 00 00       	call   801040b0 <initlock>
  lk->name = name;
80103f98:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80103f9b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80103fa1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80103fa4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80103fab:	89 43 38             	mov    %eax,0x38(%ebx)
}
80103fae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fb1:	c9                   	leave
80103fb2:	c3                   	ret
80103fb3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103fba:	00 
80103fbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103fc0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103fc0:	55                   	push   %ebp
80103fc1:	89 e5                	mov    %esp,%ebp
80103fc3:	56                   	push   %esi
80103fc4:	53                   	push   %ebx
80103fc5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103fc8:	8d 73 04             	lea    0x4(%ebx),%esi
80103fcb:	83 ec 0c             	sub    $0xc,%esp
80103fce:	56                   	push   %esi
80103fcf:	e8 cc 02 00 00       	call   801042a0 <acquire>
  while (lk->locked) {
80103fd4:	8b 13                	mov    (%ebx),%edx
80103fd6:	83 c4 10             	add    $0x10,%esp
80103fd9:	85 d2                	test   %edx,%edx
80103fdb:	74 16                	je     80103ff3 <acquiresleep+0x33>
80103fdd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80103fe0:	83 ec 08             	sub    $0x8,%esp
80103fe3:	56                   	push   %esi
80103fe4:	53                   	push   %ebx
80103fe5:	e8 36 fd ff ff       	call   80103d20 <sleep>
  while (lk->locked) {
80103fea:	8b 03                	mov    (%ebx),%eax
80103fec:	83 c4 10             	add    $0x10,%esp
80103fef:	85 c0                	test   %eax,%eax
80103ff1:	75 ed                	jne    80103fe0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80103ff3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103ff9:	e8 62 f6 ff ff       	call   80103660 <myproc>
80103ffe:	8b 40 10             	mov    0x10(%eax),%eax
80104001:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104004:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104007:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010400a:	5b                   	pop    %ebx
8010400b:	5e                   	pop    %esi
8010400c:	5d                   	pop    %ebp
  release(&lk->lk);
8010400d:	e9 2e 02 00 00       	jmp    80104240 <release>
80104012:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104019:	00 
8010401a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104020 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	56                   	push   %esi
80104024:	53                   	push   %ebx
80104025:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104028:	8d 73 04             	lea    0x4(%ebx),%esi
8010402b:	83 ec 0c             	sub    $0xc,%esp
8010402e:	56                   	push   %esi
8010402f:	e8 6c 02 00 00       	call   801042a0 <acquire>
  lk->locked = 0;
80104034:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010403a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104041:	89 1c 24             	mov    %ebx,(%esp)
80104044:	e8 97 fd ff ff       	call   80103de0 <wakeup>
  release(&lk->lk);
80104049:	83 c4 10             	add    $0x10,%esp
8010404c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010404f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104052:	5b                   	pop    %ebx
80104053:	5e                   	pop    %esi
80104054:	5d                   	pop    %ebp
  release(&lk->lk);
80104055:	e9 e6 01 00 00       	jmp    80104240 <release>
8010405a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104060 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	57                   	push   %edi
80104064:	31 ff                	xor    %edi,%edi
80104066:	56                   	push   %esi
80104067:	53                   	push   %ebx
80104068:	83 ec 18             	sub    $0x18,%esp
8010406b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010406e:	8d 73 04             	lea    0x4(%ebx),%esi
80104071:	56                   	push   %esi
80104072:	e8 29 02 00 00       	call   801042a0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104077:	8b 03                	mov    (%ebx),%eax
80104079:	83 c4 10             	add    $0x10,%esp
8010407c:	85 c0                	test   %eax,%eax
8010407e:	75 18                	jne    80104098 <holdingsleep+0x38>
  release(&lk->lk);
80104080:	83 ec 0c             	sub    $0xc,%esp
80104083:	56                   	push   %esi
80104084:	e8 b7 01 00 00       	call   80104240 <release>
  return r;
}
80104089:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010408c:	89 f8                	mov    %edi,%eax
8010408e:	5b                   	pop    %ebx
8010408f:	5e                   	pop    %esi
80104090:	5f                   	pop    %edi
80104091:	5d                   	pop    %ebp
80104092:	c3                   	ret
80104093:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104098:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010409b:	e8 c0 f5 ff ff       	call   80103660 <myproc>
801040a0:	39 58 10             	cmp    %ebx,0x10(%eax)
801040a3:	0f 94 c0             	sete   %al
801040a6:	0f b6 c0             	movzbl %al,%eax
801040a9:	89 c7                	mov    %eax,%edi
801040ab:	eb d3                	jmp    80104080 <holdingsleep+0x20>
801040ad:	66 90                	xchg   %ax,%ax
801040af:	90                   	nop

801040b0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801040b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801040b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801040bf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801040c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801040c9:	5d                   	pop    %ebp
801040ca:	c3                   	ret
801040cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801040d0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	53                   	push   %ebx
801040d4:	8b 45 08             	mov    0x8(%ebp),%eax
801040d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801040da:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801040dd:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
801040e2:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
801040e7:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801040ec:	76 10                	jbe    801040fe <getcallerpcs+0x2e>
801040ee:	eb 28                	jmp    80104118 <getcallerpcs+0x48>
801040f0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801040f6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801040fc:	77 1a                	ja     80104118 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
801040fe:	8b 5a 04             	mov    0x4(%edx),%ebx
80104101:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104104:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104107:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104109:	83 f8 0a             	cmp    $0xa,%eax
8010410c:	75 e2                	jne    801040f0 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010410e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104111:	c9                   	leave
80104112:	c3                   	ret
80104113:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104118:	8d 04 81             	lea    (%ecx,%eax,4),%eax
8010411b:	83 c1 28             	add    $0x28,%ecx
8010411e:	89 ca                	mov    %ecx,%edx
80104120:	29 c2                	sub    %eax,%edx
80104122:	83 e2 04             	and    $0x4,%edx
80104125:	74 11                	je     80104138 <getcallerpcs+0x68>
    pcs[i] = 0;
80104127:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010412d:	83 c0 04             	add    $0x4,%eax
80104130:	39 c1                	cmp    %eax,%ecx
80104132:	74 da                	je     8010410e <getcallerpcs+0x3e>
80104134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104138:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010413e:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104141:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104148:	39 c1                	cmp    %eax,%ecx
8010414a:	75 ec                	jne    80104138 <getcallerpcs+0x68>
8010414c:	eb c0                	jmp    8010410e <getcallerpcs+0x3e>
8010414e:	66 90                	xchg   %ax,%ax

80104150 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	53                   	push   %ebx
80104154:	83 ec 04             	sub    $0x4,%esp
80104157:	9c                   	pushf
80104158:	5b                   	pop    %ebx
  asm volatile("cli");
80104159:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010415a:	e8 81 f4 ff ff       	call   801035e0 <mycpu>
8010415f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104165:	85 c0                	test   %eax,%eax
80104167:	74 17                	je     80104180 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104169:	e8 72 f4 ff ff       	call   801035e0 <mycpu>
8010416e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104175:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104178:	c9                   	leave
80104179:	c3                   	ret
8010417a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104180:	e8 5b f4 ff ff       	call   801035e0 <mycpu>
80104185:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010418b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104191:	eb d6                	jmp    80104169 <pushcli+0x19>
80104193:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010419a:	00 
8010419b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801041a0 <popcli>:

void
popcli(void)
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041a6:	9c                   	pushf
801041a7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801041a8:	f6 c4 02             	test   $0x2,%ah
801041ab:	75 35                	jne    801041e2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801041ad:	e8 2e f4 ff ff       	call   801035e0 <mycpu>
801041b2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801041b9:	78 34                	js     801041ef <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801041bb:	e8 20 f4 ff ff       	call   801035e0 <mycpu>
801041c0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801041c6:	85 d2                	test   %edx,%edx
801041c8:	74 06                	je     801041d0 <popcli+0x30>
    sti();
}
801041ca:	c9                   	leave
801041cb:	c3                   	ret
801041cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801041d0:	e8 0b f4 ff ff       	call   801035e0 <mycpu>
801041d5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801041db:	85 c0                	test   %eax,%eax
801041dd:	74 eb                	je     801041ca <popcli+0x2a>
  asm volatile("sti");
801041df:	fb                   	sti
}
801041e0:	c9                   	leave
801041e1:	c3                   	ret
    panic("popcli - interruptible");
801041e2:	83 ec 0c             	sub    $0xc,%esp
801041e5:	68 3b 72 10 80       	push   $0x8010723b
801041ea:	e8 91 c1 ff ff       	call   80100380 <panic>
    panic("popcli");
801041ef:	83 ec 0c             	sub    $0xc,%esp
801041f2:	68 52 72 10 80       	push   $0x80107252
801041f7:	e8 84 c1 ff ff       	call   80100380 <panic>
801041fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104200 <holding>:
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	56                   	push   %esi
80104204:	53                   	push   %ebx
80104205:	8b 75 08             	mov    0x8(%ebp),%esi
80104208:	31 db                	xor    %ebx,%ebx
  pushcli();
8010420a:	e8 41 ff ff ff       	call   80104150 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010420f:	8b 06                	mov    (%esi),%eax
80104211:	85 c0                	test   %eax,%eax
80104213:	75 0b                	jne    80104220 <holding+0x20>
  popcli();
80104215:	e8 86 ff ff ff       	call   801041a0 <popcli>
}
8010421a:	89 d8                	mov    %ebx,%eax
8010421c:	5b                   	pop    %ebx
8010421d:	5e                   	pop    %esi
8010421e:	5d                   	pop    %ebp
8010421f:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80104220:	8b 5e 08             	mov    0x8(%esi),%ebx
80104223:	e8 b8 f3 ff ff       	call   801035e0 <mycpu>
80104228:	39 c3                	cmp    %eax,%ebx
8010422a:	0f 94 c3             	sete   %bl
  popcli();
8010422d:	e8 6e ff ff ff       	call   801041a0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104232:	0f b6 db             	movzbl %bl,%ebx
}
80104235:	89 d8                	mov    %ebx,%eax
80104237:	5b                   	pop    %ebx
80104238:	5e                   	pop    %esi
80104239:	5d                   	pop    %ebp
8010423a:	c3                   	ret
8010423b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104240 <release>:
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	56                   	push   %esi
80104244:	53                   	push   %ebx
80104245:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104248:	e8 03 ff ff ff       	call   80104150 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010424d:	8b 03                	mov    (%ebx),%eax
8010424f:	85 c0                	test   %eax,%eax
80104251:	75 15                	jne    80104268 <release+0x28>
  popcli();
80104253:	e8 48 ff ff ff       	call   801041a0 <popcli>
    panic("release");
80104258:	83 ec 0c             	sub    $0xc,%esp
8010425b:	68 59 72 10 80       	push   $0x80107259
80104260:	e8 1b c1 ff ff       	call   80100380 <panic>
80104265:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104268:	8b 73 08             	mov    0x8(%ebx),%esi
8010426b:	e8 70 f3 ff ff       	call   801035e0 <mycpu>
80104270:	39 c6                	cmp    %eax,%esi
80104272:	75 df                	jne    80104253 <release+0x13>
  popcli();
80104274:	e8 27 ff ff ff       	call   801041a0 <popcli>
  lk->pcs[0] = 0;
80104279:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104280:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104287:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010428c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104292:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104295:	5b                   	pop    %ebx
80104296:	5e                   	pop    %esi
80104297:	5d                   	pop    %ebp
  popcli();
80104298:	e9 03 ff ff ff       	jmp    801041a0 <popcli>
8010429d:	8d 76 00             	lea    0x0(%esi),%esi

801042a0 <acquire>:
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	53                   	push   %ebx
801042a4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801042a7:	e8 a4 fe ff ff       	call   80104150 <pushcli>
  if(holding(lk))
801042ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801042af:	e8 9c fe ff ff       	call   80104150 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801042b4:	8b 03                	mov    (%ebx),%eax
801042b6:	85 c0                	test   %eax,%eax
801042b8:	0f 85 b2 00 00 00    	jne    80104370 <acquire+0xd0>
  popcli();
801042be:	e8 dd fe ff ff       	call   801041a0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801042c3:	b9 01 00 00 00       	mov    $0x1,%ecx
801042c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801042cf:	00 
  while(xchg(&lk->locked, 1) != 0)
801042d0:	8b 55 08             	mov    0x8(%ebp),%edx
801042d3:	89 c8                	mov    %ecx,%eax
801042d5:	f0 87 02             	lock xchg %eax,(%edx)
801042d8:	85 c0                	test   %eax,%eax
801042da:	75 f4                	jne    801042d0 <acquire+0x30>
  __sync_synchronize();
801042dc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801042e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801042e4:	e8 f7 f2 ff ff       	call   801035e0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801042e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
801042ec:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
801042ee:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801042f1:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
801042f7:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
801042fc:	77 32                	ja     80104330 <acquire+0x90>
  ebp = (uint*)v - 2;
801042fe:	89 e8                	mov    %ebp,%eax
80104300:	eb 14                	jmp    80104316 <acquire+0x76>
80104302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104308:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010430e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104314:	77 1a                	ja     80104330 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80104316:	8b 58 04             	mov    0x4(%eax),%ebx
80104319:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010431d:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104320:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104322:	83 fa 0a             	cmp    $0xa,%edx
80104325:	75 e1                	jne    80104308 <acquire+0x68>
}
80104327:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010432a:	c9                   	leave
8010432b:	c3                   	ret
8010432c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104330:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80104334:	83 c1 34             	add    $0x34,%ecx
80104337:	89 ca                	mov    %ecx,%edx
80104339:	29 c2                	sub    %eax,%edx
8010433b:	83 e2 04             	and    $0x4,%edx
8010433e:	74 10                	je     80104350 <acquire+0xb0>
    pcs[i] = 0;
80104340:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104346:	83 c0 04             	add    $0x4,%eax
80104349:	39 c1                	cmp    %eax,%ecx
8010434b:	74 da                	je     80104327 <acquire+0x87>
8010434d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104350:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104356:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104359:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104360:	39 c1                	cmp    %eax,%ecx
80104362:	75 ec                	jne    80104350 <acquire+0xb0>
80104364:	eb c1                	jmp    80104327 <acquire+0x87>
80104366:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010436d:	00 
8010436e:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
80104370:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104373:	e8 68 f2 ff ff       	call   801035e0 <mycpu>
80104378:	39 c3                	cmp    %eax,%ebx
8010437a:	0f 85 3e ff ff ff    	jne    801042be <acquire+0x1e>
  popcli();
80104380:	e8 1b fe ff ff       	call   801041a0 <popcli>
    panic("acquire");
80104385:	83 ec 0c             	sub    $0xc,%esp
80104388:	68 61 72 10 80       	push   $0x80107261
8010438d:	e8 ee bf ff ff       	call   80100380 <panic>
80104392:	66 90                	xchg   %ax,%ax
80104394:	66 90                	xchg   %ax,%ax
80104396:	66 90                	xchg   %ax,%ax
80104398:	66 90                	xchg   %ax,%ax
8010439a:	66 90                	xchg   %ax,%ax
8010439c:	66 90                	xchg   %ax,%ax
8010439e:	66 90                	xchg   %ax,%ax

801043a0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	57                   	push   %edi
801043a4:	8b 55 08             	mov    0x8(%ebp),%edx
801043a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801043aa:	89 d0                	mov    %edx,%eax
801043ac:	09 c8                	or     %ecx,%eax
801043ae:	a8 03                	test   $0x3,%al
801043b0:	75 1e                	jne    801043d0 <memset+0x30>
    c &= 0xFF;
801043b2:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801043b6:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
801043b9:	89 d7                	mov    %edx,%edi
801043bb:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
801043c1:	fc                   	cld
801043c2:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801043c4:	8b 7d fc             	mov    -0x4(%ebp),%edi
801043c7:	89 d0                	mov    %edx,%eax
801043c9:	c9                   	leave
801043ca:	c3                   	ret
801043cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801043d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801043d3:	89 d7                	mov    %edx,%edi
801043d5:	fc                   	cld
801043d6:	f3 aa                	rep stos %al,%es:(%edi)
801043d8:	8b 7d fc             	mov    -0x4(%ebp),%edi
801043db:	89 d0                	mov    %edx,%eax
801043dd:	c9                   	leave
801043de:	c3                   	ret
801043df:	90                   	nop

801043e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	56                   	push   %esi
801043e4:	8b 75 10             	mov    0x10(%ebp),%esi
801043e7:	8b 45 08             	mov    0x8(%ebp),%eax
801043ea:	53                   	push   %ebx
801043eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801043ee:	85 f6                	test   %esi,%esi
801043f0:	74 2e                	je     80104420 <memcmp+0x40>
801043f2:	01 c6                	add    %eax,%esi
801043f4:	eb 14                	jmp    8010440a <memcmp+0x2a>
801043f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801043fd:	00 
801043fe:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104400:	83 c0 01             	add    $0x1,%eax
80104403:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104406:	39 f0                	cmp    %esi,%eax
80104408:	74 16                	je     80104420 <memcmp+0x40>
    if(*s1 != *s2)
8010440a:	0f b6 08             	movzbl (%eax),%ecx
8010440d:	0f b6 1a             	movzbl (%edx),%ebx
80104410:	38 d9                	cmp    %bl,%cl
80104412:	74 ec                	je     80104400 <memcmp+0x20>
      return *s1 - *s2;
80104414:	0f b6 c1             	movzbl %cl,%eax
80104417:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104419:	5b                   	pop    %ebx
8010441a:	5e                   	pop    %esi
8010441b:	5d                   	pop    %ebp
8010441c:	c3                   	ret
8010441d:	8d 76 00             	lea    0x0(%esi),%esi
80104420:	5b                   	pop    %ebx
  return 0;
80104421:	31 c0                	xor    %eax,%eax
}
80104423:	5e                   	pop    %esi
80104424:	5d                   	pop    %ebp
80104425:	c3                   	ret
80104426:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010442d:	00 
8010442e:	66 90                	xchg   %ax,%ax

80104430 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	57                   	push   %edi
80104434:	8b 55 08             	mov    0x8(%ebp),%edx
80104437:	8b 45 10             	mov    0x10(%ebp),%eax
8010443a:	56                   	push   %esi
8010443b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010443e:	39 d6                	cmp    %edx,%esi
80104440:	73 26                	jae    80104468 <memmove+0x38>
80104442:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104445:	39 ca                	cmp    %ecx,%edx
80104447:	73 1f                	jae    80104468 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104449:	85 c0                	test   %eax,%eax
8010444b:	74 0f                	je     8010445c <memmove+0x2c>
8010444d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80104450:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104454:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104457:	83 e8 01             	sub    $0x1,%eax
8010445a:	73 f4                	jae    80104450 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010445c:	5e                   	pop    %esi
8010445d:	89 d0                	mov    %edx,%eax
8010445f:	5f                   	pop    %edi
80104460:	5d                   	pop    %ebp
80104461:	c3                   	ret
80104462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104468:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
8010446b:	89 d7                	mov    %edx,%edi
8010446d:	85 c0                	test   %eax,%eax
8010446f:	74 eb                	je     8010445c <memmove+0x2c>
80104471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104478:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104479:	39 ce                	cmp    %ecx,%esi
8010447b:	75 fb                	jne    80104478 <memmove+0x48>
}
8010447d:	5e                   	pop    %esi
8010447e:	89 d0                	mov    %edx,%eax
80104480:	5f                   	pop    %edi
80104481:	5d                   	pop    %ebp
80104482:	c3                   	ret
80104483:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010448a:	00 
8010448b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104490 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104490:	eb 9e                	jmp    80104430 <memmove>
80104492:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104499:	00 
8010449a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044a0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	53                   	push   %ebx
801044a4:	8b 55 10             	mov    0x10(%ebp),%edx
801044a7:	8b 45 08             	mov    0x8(%ebp),%eax
801044aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
801044ad:	85 d2                	test   %edx,%edx
801044af:	75 16                	jne    801044c7 <strncmp+0x27>
801044b1:	eb 2d                	jmp    801044e0 <strncmp+0x40>
801044b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801044b8:	3a 19                	cmp    (%ecx),%bl
801044ba:	75 12                	jne    801044ce <strncmp+0x2e>
    n--, p++, q++;
801044bc:	83 c0 01             	add    $0x1,%eax
801044bf:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801044c2:	83 ea 01             	sub    $0x1,%edx
801044c5:	74 19                	je     801044e0 <strncmp+0x40>
801044c7:	0f b6 18             	movzbl (%eax),%ebx
801044ca:	84 db                	test   %bl,%bl
801044cc:	75 ea                	jne    801044b8 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801044ce:	0f b6 00             	movzbl (%eax),%eax
801044d1:	0f b6 11             	movzbl (%ecx),%edx
}
801044d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044d7:	c9                   	leave
  return (uchar)*p - (uchar)*q;
801044d8:	29 d0                	sub    %edx,%eax
}
801044da:	c3                   	ret
801044db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801044e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801044e3:	31 c0                	xor    %eax,%eax
}
801044e5:	c9                   	leave
801044e6:	c3                   	ret
801044e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801044ee:	00 
801044ef:	90                   	nop

801044f0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	57                   	push   %edi
801044f4:	56                   	push   %esi
801044f5:	8b 75 08             	mov    0x8(%ebp),%esi
801044f8:	53                   	push   %ebx
801044f9:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801044fc:	89 f0                	mov    %esi,%eax
801044fe:	eb 15                	jmp    80104515 <strncpy+0x25>
80104500:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104504:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104507:	83 c0 01             	add    $0x1,%eax
8010450a:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
8010450e:	88 48 ff             	mov    %cl,-0x1(%eax)
80104511:	84 c9                	test   %cl,%cl
80104513:	74 13                	je     80104528 <strncpy+0x38>
80104515:	89 d3                	mov    %edx,%ebx
80104517:	83 ea 01             	sub    $0x1,%edx
8010451a:	85 db                	test   %ebx,%ebx
8010451c:	7f e2                	jg     80104500 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
8010451e:	5b                   	pop    %ebx
8010451f:	89 f0                	mov    %esi,%eax
80104521:	5e                   	pop    %esi
80104522:	5f                   	pop    %edi
80104523:	5d                   	pop    %ebp
80104524:	c3                   	ret
80104525:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104528:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
8010452b:	83 e9 01             	sub    $0x1,%ecx
8010452e:	85 d2                	test   %edx,%edx
80104530:	74 ec                	je     8010451e <strncpy+0x2e>
80104532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104538:	83 c0 01             	add    $0x1,%eax
8010453b:	89 ca                	mov    %ecx,%edx
8010453d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104541:	29 c2                	sub    %eax,%edx
80104543:	85 d2                	test   %edx,%edx
80104545:	7f f1                	jg     80104538 <strncpy+0x48>
}
80104547:	5b                   	pop    %ebx
80104548:	89 f0                	mov    %esi,%eax
8010454a:	5e                   	pop    %esi
8010454b:	5f                   	pop    %edi
8010454c:	5d                   	pop    %ebp
8010454d:	c3                   	ret
8010454e:	66 90                	xchg   %ax,%ax

80104550 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	56                   	push   %esi
80104554:	8b 55 10             	mov    0x10(%ebp),%edx
80104557:	8b 75 08             	mov    0x8(%ebp),%esi
8010455a:	53                   	push   %ebx
8010455b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010455e:	85 d2                	test   %edx,%edx
80104560:	7e 25                	jle    80104587 <safestrcpy+0x37>
80104562:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104566:	89 f2                	mov    %esi,%edx
80104568:	eb 16                	jmp    80104580 <safestrcpy+0x30>
8010456a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104570:	0f b6 08             	movzbl (%eax),%ecx
80104573:	83 c0 01             	add    $0x1,%eax
80104576:	83 c2 01             	add    $0x1,%edx
80104579:	88 4a ff             	mov    %cl,-0x1(%edx)
8010457c:	84 c9                	test   %cl,%cl
8010457e:	74 04                	je     80104584 <safestrcpy+0x34>
80104580:	39 d8                	cmp    %ebx,%eax
80104582:	75 ec                	jne    80104570 <safestrcpy+0x20>
    ;
  *s = 0;
80104584:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104587:	89 f0                	mov    %esi,%eax
80104589:	5b                   	pop    %ebx
8010458a:	5e                   	pop    %esi
8010458b:	5d                   	pop    %ebp
8010458c:	c3                   	ret
8010458d:	8d 76 00             	lea    0x0(%esi),%esi

80104590 <strlen>:

int
strlen(const char *s)
{
80104590:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104591:	31 c0                	xor    %eax,%eax
{
80104593:	89 e5                	mov    %esp,%ebp
80104595:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104598:	80 3a 00             	cmpb   $0x0,(%edx)
8010459b:	74 0c                	je     801045a9 <strlen+0x19>
8010459d:	8d 76 00             	lea    0x0(%esi),%esi
801045a0:	83 c0 01             	add    $0x1,%eax
801045a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801045a7:	75 f7                	jne    801045a0 <strlen+0x10>
    ;
  return n;
}
801045a9:	5d                   	pop    %ebp
801045aa:	c3                   	ret

801045ab <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801045ab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801045af:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801045b3:	55                   	push   %ebp
  pushl %ebx
801045b4:	53                   	push   %ebx
  pushl %esi
801045b5:	56                   	push   %esi
  pushl %edi
801045b6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801045b7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801045b9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801045bb:	5f                   	pop    %edi
  popl %esi
801045bc:	5e                   	pop    %esi
  popl %ebx
801045bd:	5b                   	pop    %ebx
  popl %ebp
801045be:	5d                   	pop    %ebp
  ret
801045bf:	c3                   	ret

801045c0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	53                   	push   %ebx
801045c4:	83 ec 04             	sub    $0x4,%esp
801045c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801045ca:	e8 91 f0 ff ff       	call   80103660 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801045cf:	8b 00                	mov    (%eax),%eax
801045d1:	39 c3                	cmp    %eax,%ebx
801045d3:	73 1b                	jae    801045f0 <fetchint+0x30>
801045d5:	8d 53 04             	lea    0x4(%ebx),%edx
801045d8:	39 d0                	cmp    %edx,%eax
801045da:	72 14                	jb     801045f0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801045dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801045df:	8b 13                	mov    (%ebx),%edx
801045e1:	89 10                	mov    %edx,(%eax)
  return 0;
801045e3:	31 c0                	xor    %eax,%eax
}
801045e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045e8:	c9                   	leave
801045e9:	c3                   	ret
801045ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801045f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045f5:	eb ee                	jmp    801045e5 <fetchint+0x25>
801045f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801045fe:	00 
801045ff:	90                   	nop

80104600 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	53                   	push   %ebx
80104604:	83 ec 04             	sub    $0x4,%esp
80104607:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010460a:	e8 51 f0 ff ff       	call   80103660 <myproc>

  if(addr >= curproc->sz)
8010460f:	3b 18                	cmp    (%eax),%ebx
80104611:	73 2d                	jae    80104640 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104613:	8b 55 0c             	mov    0xc(%ebp),%edx
80104616:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104618:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010461a:	39 d3                	cmp    %edx,%ebx
8010461c:	73 22                	jae    80104640 <fetchstr+0x40>
8010461e:	89 d8                	mov    %ebx,%eax
80104620:	eb 0d                	jmp    8010462f <fetchstr+0x2f>
80104622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104628:	83 c0 01             	add    $0x1,%eax
8010462b:	39 d0                	cmp    %edx,%eax
8010462d:	73 11                	jae    80104640 <fetchstr+0x40>
    if(*s == 0)
8010462f:	80 38 00             	cmpb   $0x0,(%eax)
80104632:	75 f4                	jne    80104628 <fetchstr+0x28>
      return s - *pp;
80104634:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104636:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104639:	c9                   	leave
8010463a:	c3                   	ret
8010463b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104640:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104643:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104648:	c9                   	leave
80104649:	c3                   	ret
8010464a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104650 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	56                   	push   %esi
80104654:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104655:	e8 06 f0 ff ff       	call   80103660 <myproc>
8010465a:	8b 55 08             	mov    0x8(%ebp),%edx
8010465d:	8b 40 18             	mov    0x18(%eax),%eax
80104660:	8b 40 44             	mov    0x44(%eax),%eax
80104663:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104666:	e8 f5 ef ff ff       	call   80103660 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010466b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010466e:	8b 00                	mov    (%eax),%eax
80104670:	39 c6                	cmp    %eax,%esi
80104672:	73 1c                	jae    80104690 <argint+0x40>
80104674:	8d 53 08             	lea    0x8(%ebx),%edx
80104677:	39 d0                	cmp    %edx,%eax
80104679:	72 15                	jb     80104690 <argint+0x40>
  *ip = *(int*)(addr);
8010467b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010467e:	8b 53 04             	mov    0x4(%ebx),%edx
80104681:	89 10                	mov    %edx,(%eax)
  return 0;
80104683:	31 c0                	xor    %eax,%eax
}
80104685:	5b                   	pop    %ebx
80104686:	5e                   	pop    %esi
80104687:	5d                   	pop    %ebp
80104688:	c3                   	ret
80104689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104690:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104695:	eb ee                	jmp    80104685 <argint+0x35>
80104697:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010469e:	00 
8010469f:	90                   	nop

801046a0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	57                   	push   %edi
801046a4:	56                   	push   %esi
801046a5:	53                   	push   %ebx
801046a6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
801046a9:	e8 b2 ef ff ff       	call   80103660 <myproc>
801046ae:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801046b0:	e8 ab ef ff ff       	call   80103660 <myproc>
801046b5:	8b 55 08             	mov    0x8(%ebp),%edx
801046b8:	8b 40 18             	mov    0x18(%eax),%eax
801046bb:	8b 40 44             	mov    0x44(%eax),%eax
801046be:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801046c1:	e8 9a ef ff ff       	call   80103660 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801046c6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801046c9:	8b 00                	mov    (%eax),%eax
801046cb:	39 c7                	cmp    %eax,%edi
801046cd:	73 31                	jae    80104700 <argptr+0x60>
801046cf:	8d 4b 08             	lea    0x8(%ebx),%ecx
801046d2:	39 c8                	cmp    %ecx,%eax
801046d4:	72 2a                	jb     80104700 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801046d6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
801046d9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801046dc:	85 d2                	test   %edx,%edx
801046de:	78 20                	js     80104700 <argptr+0x60>
801046e0:	8b 16                	mov    (%esi),%edx
801046e2:	39 d0                	cmp    %edx,%eax
801046e4:	73 1a                	jae    80104700 <argptr+0x60>
801046e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801046e9:	01 c3                	add    %eax,%ebx
801046eb:	39 da                	cmp    %ebx,%edx
801046ed:	72 11                	jb     80104700 <argptr+0x60>
    return -1;
  *pp = (char*)i;
801046ef:	8b 55 0c             	mov    0xc(%ebp),%edx
801046f2:	89 02                	mov    %eax,(%edx)
  return 0;
801046f4:	31 c0                	xor    %eax,%eax
}
801046f6:	83 c4 0c             	add    $0xc,%esp
801046f9:	5b                   	pop    %ebx
801046fa:	5e                   	pop    %esi
801046fb:	5f                   	pop    %edi
801046fc:	5d                   	pop    %ebp
801046fd:	c3                   	ret
801046fe:	66 90                	xchg   %ax,%ax
    return -1;
80104700:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104705:	eb ef                	jmp    801046f6 <argptr+0x56>
80104707:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010470e:	00 
8010470f:	90                   	nop

80104710 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	56                   	push   %esi
80104714:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104715:	e8 46 ef ff ff       	call   80103660 <myproc>
8010471a:	8b 55 08             	mov    0x8(%ebp),%edx
8010471d:	8b 40 18             	mov    0x18(%eax),%eax
80104720:	8b 40 44             	mov    0x44(%eax),%eax
80104723:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104726:	e8 35 ef ff ff       	call   80103660 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010472b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010472e:	8b 00                	mov    (%eax),%eax
80104730:	39 c6                	cmp    %eax,%esi
80104732:	73 44                	jae    80104778 <argstr+0x68>
80104734:	8d 53 08             	lea    0x8(%ebx),%edx
80104737:	39 d0                	cmp    %edx,%eax
80104739:	72 3d                	jb     80104778 <argstr+0x68>
  *ip = *(int*)(addr);
8010473b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
8010473e:	e8 1d ef ff ff       	call   80103660 <myproc>
  if(addr >= curproc->sz)
80104743:	3b 18                	cmp    (%eax),%ebx
80104745:	73 31                	jae    80104778 <argstr+0x68>
  *pp = (char*)addr;
80104747:	8b 55 0c             	mov    0xc(%ebp),%edx
8010474a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010474c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010474e:	39 d3                	cmp    %edx,%ebx
80104750:	73 26                	jae    80104778 <argstr+0x68>
80104752:	89 d8                	mov    %ebx,%eax
80104754:	eb 11                	jmp    80104767 <argstr+0x57>
80104756:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010475d:	00 
8010475e:	66 90                	xchg   %ax,%ax
80104760:	83 c0 01             	add    $0x1,%eax
80104763:	39 d0                	cmp    %edx,%eax
80104765:	73 11                	jae    80104778 <argstr+0x68>
    if(*s == 0)
80104767:	80 38 00             	cmpb   $0x0,(%eax)
8010476a:	75 f4                	jne    80104760 <argstr+0x50>
      return s - *pp;
8010476c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010476e:	5b                   	pop    %ebx
8010476f:	5e                   	pop    %esi
80104770:	5d                   	pop    %ebp
80104771:	c3                   	ret
80104772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104778:	5b                   	pop    %ebx
    return -1;
80104779:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010477e:	5e                   	pop    %esi
8010477f:	5d                   	pop    %ebp
80104780:	c3                   	ret
80104781:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104788:	00 
80104789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104790 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	53                   	push   %ebx
80104794:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104797:	e8 c4 ee ff ff       	call   80103660 <myproc>
8010479c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010479e:	8b 40 18             	mov    0x18(%eax),%eax
801047a1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801047a4:	8d 50 ff             	lea    -0x1(%eax),%edx
801047a7:	83 fa 14             	cmp    $0x14,%edx
801047aa:	77 24                	ja     801047d0 <syscall+0x40>
801047ac:	8b 14 85 40 78 10 80 	mov    -0x7fef87c0(,%eax,4),%edx
801047b3:	85 d2                	test   %edx,%edx
801047b5:	74 19                	je     801047d0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801047b7:	ff d2                	call   *%edx
801047b9:	89 c2                	mov    %eax,%edx
801047bb:	8b 43 18             	mov    0x18(%ebx),%eax
801047be:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801047c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047c4:	c9                   	leave
801047c5:	c3                   	ret
801047c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801047cd:	00 
801047ce:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
801047d0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801047d1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801047d4:	50                   	push   %eax
801047d5:	ff 73 10             	push   0x10(%ebx)
801047d8:	68 69 72 10 80       	push   $0x80107269
801047dd:	e8 ce be ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
801047e2:	8b 43 18             	mov    0x18(%ebx),%eax
801047e5:	83 c4 10             	add    $0x10,%esp
801047e8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801047ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047f2:	c9                   	leave
801047f3:	c3                   	ret
801047f4:	66 90                	xchg   %ax,%ax
801047f6:	66 90                	xchg   %ax,%ax
801047f8:	66 90                	xchg   %ax,%ax
801047fa:	66 90                	xchg   %ax,%ax
801047fc:	66 90                	xchg   %ax,%ax
801047fe:	66 90                	xchg   %ax,%ax

80104800 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	57                   	push   %edi
80104804:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104805:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104808:	53                   	push   %ebx
80104809:	83 ec 34             	sub    $0x34,%esp
8010480c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010480f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104812:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104815:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104818:	57                   	push   %edi
80104819:	50                   	push   %eax
8010481a:	e8 81 d8 ff ff       	call   801020a0 <nameiparent>
8010481f:	83 c4 10             	add    $0x10,%esp
80104822:	85 c0                	test   %eax,%eax
80104824:	74 5e                	je     80104884 <create+0x84>
    return 0;
  ilock(dp);
80104826:	83 ec 0c             	sub    $0xc,%esp
80104829:	89 c3                	mov    %eax,%ebx
8010482b:	50                   	push   %eax
8010482c:	e8 6f cf ff ff       	call   801017a0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104831:	83 c4 0c             	add    $0xc,%esp
80104834:	6a 00                	push   $0x0
80104836:	57                   	push   %edi
80104837:	53                   	push   %ebx
80104838:	e8 b3 d4 ff ff       	call   80101cf0 <dirlookup>
8010483d:	83 c4 10             	add    $0x10,%esp
80104840:	89 c6                	mov    %eax,%esi
80104842:	85 c0                	test   %eax,%eax
80104844:	74 4a                	je     80104890 <create+0x90>
    iunlockput(dp);
80104846:	83 ec 0c             	sub    $0xc,%esp
80104849:	53                   	push   %ebx
8010484a:	e8 e1 d1 ff ff       	call   80101a30 <iunlockput>
    ilock(ip);
8010484f:	89 34 24             	mov    %esi,(%esp)
80104852:	e8 49 cf ff ff       	call   801017a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104857:	83 c4 10             	add    $0x10,%esp
8010485a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010485f:	75 17                	jne    80104878 <create+0x78>
80104861:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104866:	75 10                	jne    80104878 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104868:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010486b:	89 f0                	mov    %esi,%eax
8010486d:	5b                   	pop    %ebx
8010486e:	5e                   	pop    %esi
8010486f:	5f                   	pop    %edi
80104870:	5d                   	pop    %ebp
80104871:	c3                   	ret
80104872:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80104878:	83 ec 0c             	sub    $0xc,%esp
8010487b:	56                   	push   %esi
8010487c:	e8 af d1 ff ff       	call   80101a30 <iunlockput>
    return 0;
80104881:	83 c4 10             	add    $0x10,%esp
}
80104884:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104887:	31 f6                	xor    %esi,%esi
}
80104889:	5b                   	pop    %ebx
8010488a:	89 f0                	mov    %esi,%eax
8010488c:	5e                   	pop    %esi
8010488d:	5f                   	pop    %edi
8010488e:	5d                   	pop    %ebp
8010488f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104890:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104894:	83 ec 08             	sub    $0x8,%esp
80104897:	50                   	push   %eax
80104898:	ff 33                	push   (%ebx)
8010489a:	e8 91 cd ff ff       	call   80101630 <ialloc>
8010489f:	83 c4 10             	add    $0x10,%esp
801048a2:	89 c6                	mov    %eax,%esi
801048a4:	85 c0                	test   %eax,%eax
801048a6:	0f 84 bc 00 00 00    	je     80104968 <create+0x168>
  ilock(ip);
801048ac:	83 ec 0c             	sub    $0xc,%esp
801048af:	50                   	push   %eax
801048b0:	e8 eb ce ff ff       	call   801017a0 <ilock>
  ip->major = major;
801048b5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801048b9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801048bd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801048c1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801048c5:	b8 01 00 00 00       	mov    $0x1,%eax
801048ca:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801048ce:	89 34 24             	mov    %esi,(%esp)
801048d1:	e8 1a ce ff ff       	call   801016f0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801048d6:	83 c4 10             	add    $0x10,%esp
801048d9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801048de:	74 30                	je     80104910 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
801048e0:	83 ec 04             	sub    $0x4,%esp
801048e3:	ff 76 04             	push   0x4(%esi)
801048e6:	57                   	push   %edi
801048e7:	53                   	push   %ebx
801048e8:	e8 d3 d6 ff ff       	call   80101fc0 <dirlink>
801048ed:	83 c4 10             	add    $0x10,%esp
801048f0:	85 c0                	test   %eax,%eax
801048f2:	78 67                	js     8010495b <create+0x15b>
  iunlockput(dp);
801048f4:	83 ec 0c             	sub    $0xc,%esp
801048f7:	53                   	push   %ebx
801048f8:	e8 33 d1 ff ff       	call   80101a30 <iunlockput>
  return ip;
801048fd:	83 c4 10             	add    $0x10,%esp
}
80104900:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104903:	89 f0                	mov    %esi,%eax
80104905:	5b                   	pop    %ebx
80104906:	5e                   	pop    %esi
80104907:	5f                   	pop    %edi
80104908:	5d                   	pop    %ebp
80104909:	c3                   	ret
8010490a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104910:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104913:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104918:	53                   	push   %ebx
80104919:	e8 d2 cd ff ff       	call   801016f0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010491e:	83 c4 0c             	add    $0xc,%esp
80104921:	ff 76 04             	push   0x4(%esi)
80104924:	68 a1 72 10 80       	push   $0x801072a1
80104929:	56                   	push   %esi
8010492a:	e8 91 d6 ff ff       	call   80101fc0 <dirlink>
8010492f:	83 c4 10             	add    $0x10,%esp
80104932:	85 c0                	test   %eax,%eax
80104934:	78 18                	js     8010494e <create+0x14e>
80104936:	83 ec 04             	sub    $0x4,%esp
80104939:	ff 73 04             	push   0x4(%ebx)
8010493c:	68 a0 72 10 80       	push   $0x801072a0
80104941:	56                   	push   %esi
80104942:	e8 79 d6 ff ff       	call   80101fc0 <dirlink>
80104947:	83 c4 10             	add    $0x10,%esp
8010494a:	85 c0                	test   %eax,%eax
8010494c:	79 92                	jns    801048e0 <create+0xe0>
      panic("create dots");
8010494e:	83 ec 0c             	sub    $0xc,%esp
80104951:	68 94 72 10 80       	push   $0x80107294
80104956:	e8 25 ba ff ff       	call   80100380 <panic>
    panic("create: dirlink");
8010495b:	83 ec 0c             	sub    $0xc,%esp
8010495e:	68 a3 72 10 80       	push   $0x801072a3
80104963:	e8 18 ba ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104968:	83 ec 0c             	sub    $0xc,%esp
8010496b:	68 85 72 10 80       	push   $0x80107285
80104970:	e8 0b ba ff ff       	call   80100380 <panic>
80104975:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010497c:	00 
8010497d:	8d 76 00             	lea    0x0(%esi),%esi

80104980 <sys_dup>:
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	56                   	push   %esi
80104984:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104985:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104988:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010498b:	50                   	push   %eax
8010498c:	6a 00                	push   $0x0
8010498e:	e8 bd fc ff ff       	call   80104650 <argint>
80104993:	83 c4 10             	add    $0x10,%esp
80104996:	85 c0                	test   %eax,%eax
80104998:	78 36                	js     801049d0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010499a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010499e:	77 30                	ja     801049d0 <sys_dup+0x50>
801049a0:	e8 bb ec ff ff       	call   80103660 <myproc>
801049a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049a8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801049ac:	85 f6                	test   %esi,%esi
801049ae:	74 20                	je     801049d0 <sys_dup+0x50>
  struct proc *curproc = myproc();
801049b0:	e8 ab ec ff ff       	call   80103660 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801049b5:	31 db                	xor    %ebx,%ebx
801049b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801049be:	00 
801049bf:	90                   	nop
    if(curproc->ofile[fd] == 0){
801049c0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801049c4:	85 d2                	test   %edx,%edx
801049c6:	74 18                	je     801049e0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
801049c8:	83 c3 01             	add    $0x1,%ebx
801049cb:	83 fb 10             	cmp    $0x10,%ebx
801049ce:	75 f0                	jne    801049c0 <sys_dup+0x40>
}
801049d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801049d3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801049d8:	89 d8                	mov    %ebx,%eax
801049da:	5b                   	pop    %ebx
801049db:	5e                   	pop    %esi
801049dc:	5d                   	pop    %ebp
801049dd:	c3                   	ret
801049de:	66 90                	xchg   %ax,%ax
  filedup(f);
801049e0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801049e3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801049e7:	56                   	push   %esi
801049e8:	e8 d3 c4 ff ff       	call   80100ec0 <filedup>
  return fd;
801049ed:	83 c4 10             	add    $0x10,%esp
}
801049f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049f3:	89 d8                	mov    %ebx,%eax
801049f5:	5b                   	pop    %ebx
801049f6:	5e                   	pop    %esi
801049f7:	5d                   	pop    %ebp
801049f8:	c3                   	ret
801049f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a00 <sys_read>:
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	56                   	push   %esi
80104a04:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104a05:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104a08:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104a0b:	53                   	push   %ebx
80104a0c:	6a 00                	push   $0x0
80104a0e:	e8 3d fc ff ff       	call   80104650 <argint>
80104a13:	83 c4 10             	add    $0x10,%esp
80104a16:	85 c0                	test   %eax,%eax
80104a18:	78 5e                	js     80104a78 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104a1a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104a1e:	77 58                	ja     80104a78 <sys_read+0x78>
80104a20:	e8 3b ec ff ff       	call   80103660 <myproc>
80104a25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a28:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104a2c:	85 f6                	test   %esi,%esi
80104a2e:	74 48                	je     80104a78 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a30:	83 ec 08             	sub    $0x8,%esp
80104a33:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a36:	50                   	push   %eax
80104a37:	6a 02                	push   $0x2
80104a39:	e8 12 fc ff ff       	call   80104650 <argint>
80104a3e:	83 c4 10             	add    $0x10,%esp
80104a41:	85 c0                	test   %eax,%eax
80104a43:	78 33                	js     80104a78 <sys_read+0x78>
80104a45:	83 ec 04             	sub    $0x4,%esp
80104a48:	ff 75 f0             	push   -0x10(%ebp)
80104a4b:	53                   	push   %ebx
80104a4c:	6a 01                	push   $0x1
80104a4e:	e8 4d fc ff ff       	call   801046a0 <argptr>
80104a53:	83 c4 10             	add    $0x10,%esp
80104a56:	85 c0                	test   %eax,%eax
80104a58:	78 1e                	js     80104a78 <sys_read+0x78>
  return fileread(f, p, n);
80104a5a:	83 ec 04             	sub    $0x4,%esp
80104a5d:	ff 75 f0             	push   -0x10(%ebp)
80104a60:	ff 75 f4             	push   -0xc(%ebp)
80104a63:	56                   	push   %esi
80104a64:	e8 d7 c5 ff ff       	call   80101040 <fileread>
80104a69:	83 c4 10             	add    $0x10,%esp
}
80104a6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a6f:	5b                   	pop    %ebx
80104a70:	5e                   	pop    %esi
80104a71:	5d                   	pop    %ebp
80104a72:	c3                   	ret
80104a73:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80104a78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a7d:	eb ed                	jmp    80104a6c <sys_read+0x6c>
80104a7f:	90                   	nop

80104a80 <sys_write>:
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	56                   	push   %esi
80104a84:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104a85:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104a88:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104a8b:	53                   	push   %ebx
80104a8c:	6a 00                	push   $0x0
80104a8e:	e8 bd fb ff ff       	call   80104650 <argint>
80104a93:	83 c4 10             	add    $0x10,%esp
80104a96:	85 c0                	test   %eax,%eax
80104a98:	78 5e                	js     80104af8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104a9a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104a9e:	77 58                	ja     80104af8 <sys_write+0x78>
80104aa0:	e8 bb eb ff ff       	call   80103660 <myproc>
80104aa5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104aa8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104aac:	85 f6                	test   %esi,%esi
80104aae:	74 48                	je     80104af8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ab0:	83 ec 08             	sub    $0x8,%esp
80104ab3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ab6:	50                   	push   %eax
80104ab7:	6a 02                	push   $0x2
80104ab9:	e8 92 fb ff ff       	call   80104650 <argint>
80104abe:	83 c4 10             	add    $0x10,%esp
80104ac1:	85 c0                	test   %eax,%eax
80104ac3:	78 33                	js     80104af8 <sys_write+0x78>
80104ac5:	83 ec 04             	sub    $0x4,%esp
80104ac8:	ff 75 f0             	push   -0x10(%ebp)
80104acb:	53                   	push   %ebx
80104acc:	6a 01                	push   $0x1
80104ace:	e8 cd fb ff ff       	call   801046a0 <argptr>
80104ad3:	83 c4 10             	add    $0x10,%esp
80104ad6:	85 c0                	test   %eax,%eax
80104ad8:	78 1e                	js     80104af8 <sys_write+0x78>
  return filewrite(f, p, n);
80104ada:	83 ec 04             	sub    $0x4,%esp
80104add:	ff 75 f0             	push   -0x10(%ebp)
80104ae0:	ff 75 f4             	push   -0xc(%ebp)
80104ae3:	56                   	push   %esi
80104ae4:	e8 e7 c5 ff ff       	call   801010d0 <filewrite>
80104ae9:	83 c4 10             	add    $0x10,%esp
}
80104aec:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104aef:	5b                   	pop    %ebx
80104af0:	5e                   	pop    %esi
80104af1:	5d                   	pop    %ebp
80104af2:	c3                   	ret
80104af3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80104af8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104afd:	eb ed                	jmp    80104aec <sys_write+0x6c>
80104aff:	90                   	nop

80104b00 <sys_close>:
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	56                   	push   %esi
80104b04:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104b05:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104b08:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104b0b:	50                   	push   %eax
80104b0c:	6a 00                	push   $0x0
80104b0e:	e8 3d fb ff ff       	call   80104650 <argint>
80104b13:	83 c4 10             	add    $0x10,%esp
80104b16:	85 c0                	test   %eax,%eax
80104b18:	78 3e                	js     80104b58 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104b1a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104b1e:	77 38                	ja     80104b58 <sys_close+0x58>
80104b20:	e8 3b eb ff ff       	call   80103660 <myproc>
80104b25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b28:	8d 5a 08             	lea    0x8(%edx),%ebx
80104b2b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104b2f:	85 f6                	test   %esi,%esi
80104b31:	74 25                	je     80104b58 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104b33:	e8 28 eb ff ff       	call   80103660 <myproc>
  fileclose(f);
80104b38:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104b3b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104b42:	00 
  fileclose(f);
80104b43:	56                   	push   %esi
80104b44:	e8 c7 c3 ff ff       	call   80100f10 <fileclose>
  return 0;
80104b49:	83 c4 10             	add    $0x10,%esp
80104b4c:	31 c0                	xor    %eax,%eax
}
80104b4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b51:	5b                   	pop    %ebx
80104b52:	5e                   	pop    %esi
80104b53:	5d                   	pop    %ebp
80104b54:	c3                   	ret
80104b55:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104b58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b5d:	eb ef                	jmp    80104b4e <sys_close+0x4e>
80104b5f:	90                   	nop

80104b60 <sys_fstat>:
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	56                   	push   %esi
80104b64:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104b65:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104b68:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104b6b:	53                   	push   %ebx
80104b6c:	6a 00                	push   $0x0
80104b6e:	e8 dd fa ff ff       	call   80104650 <argint>
80104b73:	83 c4 10             	add    $0x10,%esp
80104b76:	85 c0                	test   %eax,%eax
80104b78:	78 46                	js     80104bc0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104b7a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104b7e:	77 40                	ja     80104bc0 <sys_fstat+0x60>
80104b80:	e8 db ea ff ff       	call   80103660 <myproc>
80104b85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b88:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104b8c:	85 f6                	test   %esi,%esi
80104b8e:	74 30                	je     80104bc0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104b90:	83 ec 04             	sub    $0x4,%esp
80104b93:	6a 14                	push   $0x14
80104b95:	53                   	push   %ebx
80104b96:	6a 01                	push   $0x1
80104b98:	e8 03 fb ff ff       	call   801046a0 <argptr>
80104b9d:	83 c4 10             	add    $0x10,%esp
80104ba0:	85 c0                	test   %eax,%eax
80104ba2:	78 1c                	js     80104bc0 <sys_fstat+0x60>
  return filestat(f, st);
80104ba4:	83 ec 08             	sub    $0x8,%esp
80104ba7:	ff 75 f4             	push   -0xc(%ebp)
80104baa:	56                   	push   %esi
80104bab:	e8 40 c4 ff ff       	call   80100ff0 <filestat>
80104bb0:	83 c4 10             	add    $0x10,%esp
}
80104bb3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bb6:	5b                   	pop    %ebx
80104bb7:	5e                   	pop    %esi
80104bb8:	5d                   	pop    %ebp
80104bb9:	c3                   	ret
80104bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bc5:	eb ec                	jmp    80104bb3 <sys_fstat+0x53>
80104bc7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104bce:	00 
80104bcf:	90                   	nop

80104bd0 <sys_link>:
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	57                   	push   %edi
80104bd4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104bd5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104bd8:	53                   	push   %ebx
80104bd9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104bdc:	50                   	push   %eax
80104bdd:	6a 00                	push   $0x0
80104bdf:	e8 2c fb ff ff       	call   80104710 <argstr>
80104be4:	83 c4 10             	add    $0x10,%esp
80104be7:	85 c0                	test   %eax,%eax
80104be9:	0f 88 fb 00 00 00    	js     80104cea <sys_link+0x11a>
80104bef:	83 ec 08             	sub    $0x8,%esp
80104bf2:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104bf5:	50                   	push   %eax
80104bf6:	6a 01                	push   $0x1
80104bf8:	e8 13 fb ff ff       	call   80104710 <argstr>
80104bfd:	83 c4 10             	add    $0x10,%esp
80104c00:	85 c0                	test   %eax,%eax
80104c02:	0f 88 e2 00 00 00    	js     80104cea <sys_link+0x11a>
  begin_op();
80104c08:	e8 33 de ff ff       	call   80102a40 <begin_op>
  if((ip = namei(old)) == 0){
80104c0d:	83 ec 0c             	sub    $0xc,%esp
80104c10:	ff 75 d4             	push   -0x2c(%ebp)
80104c13:	e8 68 d4 ff ff       	call   80102080 <namei>
80104c18:	83 c4 10             	add    $0x10,%esp
80104c1b:	89 c3                	mov    %eax,%ebx
80104c1d:	85 c0                	test   %eax,%eax
80104c1f:	0f 84 df 00 00 00    	je     80104d04 <sys_link+0x134>
  ilock(ip);
80104c25:	83 ec 0c             	sub    $0xc,%esp
80104c28:	50                   	push   %eax
80104c29:	e8 72 cb ff ff       	call   801017a0 <ilock>
  if(ip->type == T_DIR){
80104c2e:	83 c4 10             	add    $0x10,%esp
80104c31:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c36:	0f 84 b5 00 00 00    	je     80104cf1 <sys_link+0x121>
  iupdate(ip);
80104c3c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104c3f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104c44:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104c47:	53                   	push   %ebx
80104c48:	e8 a3 ca ff ff       	call   801016f0 <iupdate>
  iunlock(ip);
80104c4d:	89 1c 24             	mov    %ebx,(%esp)
80104c50:	e8 2b cc ff ff       	call   80101880 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104c55:	58                   	pop    %eax
80104c56:	5a                   	pop    %edx
80104c57:	57                   	push   %edi
80104c58:	ff 75 d0             	push   -0x30(%ebp)
80104c5b:	e8 40 d4 ff ff       	call   801020a0 <nameiparent>
80104c60:	83 c4 10             	add    $0x10,%esp
80104c63:	89 c6                	mov    %eax,%esi
80104c65:	85 c0                	test   %eax,%eax
80104c67:	74 5b                	je     80104cc4 <sys_link+0xf4>
  ilock(dp);
80104c69:	83 ec 0c             	sub    $0xc,%esp
80104c6c:	50                   	push   %eax
80104c6d:	e8 2e cb ff ff       	call   801017a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104c72:	8b 03                	mov    (%ebx),%eax
80104c74:	83 c4 10             	add    $0x10,%esp
80104c77:	39 06                	cmp    %eax,(%esi)
80104c79:	75 3d                	jne    80104cb8 <sys_link+0xe8>
80104c7b:	83 ec 04             	sub    $0x4,%esp
80104c7e:	ff 73 04             	push   0x4(%ebx)
80104c81:	57                   	push   %edi
80104c82:	56                   	push   %esi
80104c83:	e8 38 d3 ff ff       	call   80101fc0 <dirlink>
80104c88:	83 c4 10             	add    $0x10,%esp
80104c8b:	85 c0                	test   %eax,%eax
80104c8d:	78 29                	js     80104cb8 <sys_link+0xe8>
  iunlockput(dp);
80104c8f:	83 ec 0c             	sub    $0xc,%esp
80104c92:	56                   	push   %esi
80104c93:	e8 98 cd ff ff       	call   80101a30 <iunlockput>
  iput(ip);
80104c98:	89 1c 24             	mov    %ebx,(%esp)
80104c9b:	e8 30 cc ff ff       	call   801018d0 <iput>
  end_op();
80104ca0:	e8 0b de ff ff       	call   80102ab0 <end_op>
  return 0;
80104ca5:	83 c4 10             	add    $0x10,%esp
80104ca8:	31 c0                	xor    %eax,%eax
}
80104caa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cad:	5b                   	pop    %ebx
80104cae:	5e                   	pop    %esi
80104caf:	5f                   	pop    %edi
80104cb0:	5d                   	pop    %ebp
80104cb1:	c3                   	ret
80104cb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104cb8:	83 ec 0c             	sub    $0xc,%esp
80104cbb:	56                   	push   %esi
80104cbc:	e8 6f cd ff ff       	call   80101a30 <iunlockput>
    goto bad;
80104cc1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104cc4:	83 ec 0c             	sub    $0xc,%esp
80104cc7:	53                   	push   %ebx
80104cc8:	e8 d3 ca ff ff       	call   801017a0 <ilock>
  ip->nlink--;
80104ccd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104cd2:	89 1c 24             	mov    %ebx,(%esp)
80104cd5:	e8 16 ca ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
80104cda:	89 1c 24             	mov    %ebx,(%esp)
80104cdd:	e8 4e cd ff ff       	call   80101a30 <iunlockput>
  end_op();
80104ce2:	e8 c9 dd ff ff       	call   80102ab0 <end_op>
  return -1;
80104ce7:	83 c4 10             	add    $0x10,%esp
    return -1;
80104cea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cef:	eb b9                	jmp    80104caa <sys_link+0xda>
    iunlockput(ip);
80104cf1:	83 ec 0c             	sub    $0xc,%esp
80104cf4:	53                   	push   %ebx
80104cf5:	e8 36 cd ff ff       	call   80101a30 <iunlockput>
    end_op();
80104cfa:	e8 b1 dd ff ff       	call   80102ab0 <end_op>
    return -1;
80104cff:	83 c4 10             	add    $0x10,%esp
80104d02:	eb e6                	jmp    80104cea <sys_link+0x11a>
    end_op();
80104d04:	e8 a7 dd ff ff       	call   80102ab0 <end_op>
    return -1;
80104d09:	eb df                	jmp    80104cea <sys_link+0x11a>
80104d0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104d10 <sys_unlink>:
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	57                   	push   %edi
80104d14:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80104d15:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80104d18:	53                   	push   %ebx
80104d19:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80104d1c:	50                   	push   %eax
80104d1d:	6a 00                	push   $0x0
80104d1f:	e8 ec f9 ff ff       	call   80104710 <argstr>
80104d24:	83 c4 10             	add    $0x10,%esp
80104d27:	85 c0                	test   %eax,%eax
80104d29:	0f 88 54 01 00 00    	js     80104e83 <sys_unlink+0x173>
  begin_op();
80104d2f:	e8 0c dd ff ff       	call   80102a40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104d34:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104d37:	83 ec 08             	sub    $0x8,%esp
80104d3a:	53                   	push   %ebx
80104d3b:	ff 75 c0             	push   -0x40(%ebp)
80104d3e:	e8 5d d3 ff ff       	call   801020a0 <nameiparent>
80104d43:	83 c4 10             	add    $0x10,%esp
80104d46:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104d49:	85 c0                	test   %eax,%eax
80104d4b:	0f 84 58 01 00 00    	je     80104ea9 <sys_unlink+0x199>
  ilock(dp);
80104d51:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80104d54:	83 ec 0c             	sub    $0xc,%esp
80104d57:	57                   	push   %edi
80104d58:	e8 43 ca ff ff       	call   801017a0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104d5d:	58                   	pop    %eax
80104d5e:	5a                   	pop    %edx
80104d5f:	68 a1 72 10 80       	push   $0x801072a1
80104d64:	53                   	push   %ebx
80104d65:	e8 66 cf ff ff       	call   80101cd0 <namecmp>
80104d6a:	83 c4 10             	add    $0x10,%esp
80104d6d:	85 c0                	test   %eax,%eax
80104d6f:	0f 84 fb 00 00 00    	je     80104e70 <sys_unlink+0x160>
80104d75:	83 ec 08             	sub    $0x8,%esp
80104d78:	68 a0 72 10 80       	push   $0x801072a0
80104d7d:	53                   	push   %ebx
80104d7e:	e8 4d cf ff ff       	call   80101cd0 <namecmp>
80104d83:	83 c4 10             	add    $0x10,%esp
80104d86:	85 c0                	test   %eax,%eax
80104d88:	0f 84 e2 00 00 00    	je     80104e70 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104d8e:	83 ec 04             	sub    $0x4,%esp
80104d91:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104d94:	50                   	push   %eax
80104d95:	53                   	push   %ebx
80104d96:	57                   	push   %edi
80104d97:	e8 54 cf ff ff       	call   80101cf0 <dirlookup>
80104d9c:	83 c4 10             	add    $0x10,%esp
80104d9f:	89 c3                	mov    %eax,%ebx
80104da1:	85 c0                	test   %eax,%eax
80104da3:	0f 84 c7 00 00 00    	je     80104e70 <sys_unlink+0x160>
  ilock(ip);
80104da9:	83 ec 0c             	sub    $0xc,%esp
80104dac:	50                   	push   %eax
80104dad:	e8 ee c9 ff ff       	call   801017a0 <ilock>
  if(ip->nlink < 1)
80104db2:	83 c4 10             	add    $0x10,%esp
80104db5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104dba:	0f 8e 0a 01 00 00    	jle    80104eca <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104dc0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104dc5:	8d 7d d8             	lea    -0x28(%ebp),%edi
80104dc8:	74 66                	je     80104e30 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80104dca:	83 ec 04             	sub    $0x4,%esp
80104dcd:	6a 10                	push   $0x10
80104dcf:	6a 00                	push   $0x0
80104dd1:	57                   	push   %edi
80104dd2:	e8 c9 f5 ff ff       	call   801043a0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104dd7:	6a 10                	push   $0x10
80104dd9:	ff 75 c4             	push   -0x3c(%ebp)
80104ddc:	57                   	push   %edi
80104ddd:	ff 75 b4             	push   -0x4c(%ebp)
80104de0:	e8 cb cd ff ff       	call   80101bb0 <writei>
80104de5:	83 c4 20             	add    $0x20,%esp
80104de8:	83 f8 10             	cmp    $0x10,%eax
80104deb:	0f 85 cc 00 00 00    	jne    80104ebd <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
80104df1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104df6:	0f 84 94 00 00 00    	je     80104e90 <sys_unlink+0x180>
  iunlockput(dp);
80104dfc:	83 ec 0c             	sub    $0xc,%esp
80104dff:	ff 75 b4             	push   -0x4c(%ebp)
80104e02:	e8 29 cc ff ff       	call   80101a30 <iunlockput>
  ip->nlink--;
80104e07:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104e0c:	89 1c 24             	mov    %ebx,(%esp)
80104e0f:	e8 dc c8 ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
80104e14:	89 1c 24             	mov    %ebx,(%esp)
80104e17:	e8 14 cc ff ff       	call   80101a30 <iunlockput>
  end_op();
80104e1c:	e8 8f dc ff ff       	call   80102ab0 <end_op>
  return 0;
80104e21:	83 c4 10             	add    $0x10,%esp
80104e24:	31 c0                	xor    %eax,%eax
}
80104e26:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e29:	5b                   	pop    %ebx
80104e2a:	5e                   	pop    %esi
80104e2b:	5f                   	pop    %edi
80104e2c:	5d                   	pop    %ebp
80104e2d:	c3                   	ret
80104e2e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104e30:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104e34:	76 94                	jbe    80104dca <sys_unlink+0xba>
80104e36:	be 20 00 00 00       	mov    $0x20,%esi
80104e3b:	eb 0b                	jmp    80104e48 <sys_unlink+0x138>
80104e3d:	8d 76 00             	lea    0x0(%esi),%esi
80104e40:	83 c6 10             	add    $0x10,%esi
80104e43:	3b 73 58             	cmp    0x58(%ebx),%esi
80104e46:	73 82                	jae    80104dca <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104e48:	6a 10                	push   $0x10
80104e4a:	56                   	push   %esi
80104e4b:	57                   	push   %edi
80104e4c:	53                   	push   %ebx
80104e4d:	e8 5e cc ff ff       	call   80101ab0 <readi>
80104e52:	83 c4 10             	add    $0x10,%esp
80104e55:	83 f8 10             	cmp    $0x10,%eax
80104e58:	75 56                	jne    80104eb0 <sys_unlink+0x1a0>
    if(de.inum != 0)
80104e5a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104e5f:	74 df                	je     80104e40 <sys_unlink+0x130>
    iunlockput(ip);
80104e61:	83 ec 0c             	sub    $0xc,%esp
80104e64:	53                   	push   %ebx
80104e65:	e8 c6 cb ff ff       	call   80101a30 <iunlockput>
    goto bad;
80104e6a:	83 c4 10             	add    $0x10,%esp
80104e6d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80104e70:	83 ec 0c             	sub    $0xc,%esp
80104e73:	ff 75 b4             	push   -0x4c(%ebp)
80104e76:	e8 b5 cb ff ff       	call   80101a30 <iunlockput>
  end_op();
80104e7b:	e8 30 dc ff ff       	call   80102ab0 <end_op>
  return -1;
80104e80:	83 c4 10             	add    $0x10,%esp
    return -1;
80104e83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e88:	eb 9c                	jmp    80104e26 <sys_unlink+0x116>
80104e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80104e90:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80104e93:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80104e96:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104e9b:	50                   	push   %eax
80104e9c:	e8 4f c8 ff ff       	call   801016f0 <iupdate>
80104ea1:	83 c4 10             	add    $0x10,%esp
80104ea4:	e9 53 ff ff ff       	jmp    80104dfc <sys_unlink+0xec>
    end_op();
80104ea9:	e8 02 dc ff ff       	call   80102ab0 <end_op>
    return -1;
80104eae:	eb d3                	jmp    80104e83 <sys_unlink+0x173>
      panic("isdirempty: readi");
80104eb0:	83 ec 0c             	sub    $0xc,%esp
80104eb3:	68 c5 72 10 80       	push   $0x801072c5
80104eb8:	e8 c3 b4 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
80104ebd:	83 ec 0c             	sub    $0xc,%esp
80104ec0:	68 d7 72 10 80       	push   $0x801072d7
80104ec5:	e8 b6 b4 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
80104eca:	83 ec 0c             	sub    $0xc,%esp
80104ecd:	68 b3 72 10 80       	push   $0x801072b3
80104ed2:	e8 a9 b4 ff ff       	call   80100380 <panic>
80104ed7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ede:	00 
80104edf:	90                   	nop

80104ee0 <sys_open>:

int
sys_open(void)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	57                   	push   %edi
80104ee4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104ee5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80104ee8:	53                   	push   %ebx
80104ee9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104eec:	50                   	push   %eax
80104eed:	6a 00                	push   $0x0
80104eef:	e8 1c f8 ff ff       	call   80104710 <argstr>
80104ef4:	83 c4 10             	add    $0x10,%esp
80104ef7:	85 c0                	test   %eax,%eax
80104ef9:	0f 88 8e 00 00 00    	js     80104f8d <sys_open+0xad>
80104eff:	83 ec 08             	sub    $0x8,%esp
80104f02:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104f05:	50                   	push   %eax
80104f06:	6a 01                	push   $0x1
80104f08:	e8 43 f7 ff ff       	call   80104650 <argint>
80104f0d:	83 c4 10             	add    $0x10,%esp
80104f10:	85 c0                	test   %eax,%eax
80104f12:	78 79                	js     80104f8d <sys_open+0xad>
    return -1;

  begin_op();
80104f14:	e8 27 db ff ff       	call   80102a40 <begin_op>

  if(omode & O_CREATE){
80104f19:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104f1d:	75 79                	jne    80104f98 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104f1f:	83 ec 0c             	sub    $0xc,%esp
80104f22:	ff 75 e0             	push   -0x20(%ebp)
80104f25:	e8 56 d1 ff ff       	call   80102080 <namei>
80104f2a:	83 c4 10             	add    $0x10,%esp
80104f2d:	89 c6                	mov    %eax,%esi
80104f2f:	85 c0                	test   %eax,%eax
80104f31:	0f 84 7e 00 00 00    	je     80104fb5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80104f37:	83 ec 0c             	sub    $0xc,%esp
80104f3a:	50                   	push   %eax
80104f3b:	e8 60 c8 ff ff       	call   801017a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104f40:	83 c4 10             	add    $0x10,%esp
80104f43:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104f48:	0f 84 ba 00 00 00    	je     80105008 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104f4e:	e8 fd be ff ff       	call   80100e50 <filealloc>
80104f53:	89 c7                	mov    %eax,%edi
80104f55:	85 c0                	test   %eax,%eax
80104f57:	74 23                	je     80104f7c <sys_open+0x9c>
  struct proc *curproc = myproc();
80104f59:	e8 02 e7 ff ff       	call   80103660 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104f5e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80104f60:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104f64:	85 d2                	test   %edx,%edx
80104f66:	74 58                	je     80104fc0 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80104f68:	83 c3 01             	add    $0x1,%ebx
80104f6b:	83 fb 10             	cmp    $0x10,%ebx
80104f6e:	75 f0                	jne    80104f60 <sys_open+0x80>
    if(f)
      fileclose(f);
80104f70:	83 ec 0c             	sub    $0xc,%esp
80104f73:	57                   	push   %edi
80104f74:	e8 97 bf ff ff       	call   80100f10 <fileclose>
80104f79:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104f7c:	83 ec 0c             	sub    $0xc,%esp
80104f7f:	56                   	push   %esi
80104f80:	e8 ab ca ff ff       	call   80101a30 <iunlockput>
    end_op();
80104f85:	e8 26 db ff ff       	call   80102ab0 <end_op>
    return -1;
80104f8a:	83 c4 10             	add    $0x10,%esp
    return -1;
80104f8d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104f92:	eb 65                	jmp    80104ff9 <sys_open+0x119>
80104f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80104f98:	83 ec 0c             	sub    $0xc,%esp
80104f9b:	31 c9                	xor    %ecx,%ecx
80104f9d:	ba 02 00 00 00       	mov    $0x2,%edx
80104fa2:	6a 00                	push   $0x0
80104fa4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104fa7:	e8 54 f8 ff ff       	call   80104800 <create>
    if(ip == 0){
80104fac:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80104faf:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104fb1:	85 c0                	test   %eax,%eax
80104fb3:	75 99                	jne    80104f4e <sys_open+0x6e>
      end_op();
80104fb5:	e8 f6 da ff ff       	call   80102ab0 <end_op>
      return -1;
80104fba:	eb d1                	jmp    80104f8d <sys_open+0xad>
80104fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80104fc0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104fc3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80104fc7:	56                   	push   %esi
80104fc8:	e8 b3 c8 ff ff       	call   80101880 <iunlock>
  end_op();
80104fcd:	e8 de da ff ff       	call   80102ab0 <end_op>

  f->type = FD_INODE;
80104fd2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104fd8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104fdb:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80104fde:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80104fe1:	89 d0                	mov    %edx,%eax
  f->off = 0;
80104fe3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80104fea:	f7 d0                	not    %eax
80104fec:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104fef:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80104ff2:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104ff5:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80104ff9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ffc:	89 d8                	mov    %ebx,%eax
80104ffe:	5b                   	pop    %ebx
80104fff:	5e                   	pop    %esi
80105000:	5f                   	pop    %edi
80105001:	5d                   	pop    %ebp
80105002:	c3                   	ret
80105003:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105008:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010500b:	85 c9                	test   %ecx,%ecx
8010500d:	0f 84 3b ff ff ff    	je     80104f4e <sys_open+0x6e>
80105013:	e9 64 ff ff ff       	jmp    80104f7c <sys_open+0x9c>
80105018:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010501f:	00 

80105020 <sys_mkdir>:

int
sys_mkdir(void)
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105026:	e8 15 da ff ff       	call   80102a40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010502b:	83 ec 08             	sub    $0x8,%esp
8010502e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105031:	50                   	push   %eax
80105032:	6a 00                	push   $0x0
80105034:	e8 d7 f6 ff ff       	call   80104710 <argstr>
80105039:	83 c4 10             	add    $0x10,%esp
8010503c:	85 c0                	test   %eax,%eax
8010503e:	78 30                	js     80105070 <sys_mkdir+0x50>
80105040:	83 ec 0c             	sub    $0xc,%esp
80105043:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105046:	31 c9                	xor    %ecx,%ecx
80105048:	ba 01 00 00 00       	mov    $0x1,%edx
8010504d:	6a 00                	push   $0x0
8010504f:	e8 ac f7 ff ff       	call   80104800 <create>
80105054:	83 c4 10             	add    $0x10,%esp
80105057:	85 c0                	test   %eax,%eax
80105059:	74 15                	je     80105070 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010505b:	83 ec 0c             	sub    $0xc,%esp
8010505e:	50                   	push   %eax
8010505f:	e8 cc c9 ff ff       	call   80101a30 <iunlockput>
  end_op();
80105064:	e8 47 da ff ff       	call   80102ab0 <end_op>
  return 0;
80105069:	83 c4 10             	add    $0x10,%esp
8010506c:	31 c0                	xor    %eax,%eax
}
8010506e:	c9                   	leave
8010506f:	c3                   	ret
    end_op();
80105070:	e8 3b da ff ff       	call   80102ab0 <end_op>
    return -1;
80105075:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010507a:	c9                   	leave
8010507b:	c3                   	ret
8010507c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105080 <sys_mknod>:

int
sys_mknod(void)
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105086:	e8 b5 d9 ff ff       	call   80102a40 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010508b:	83 ec 08             	sub    $0x8,%esp
8010508e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105091:	50                   	push   %eax
80105092:	6a 00                	push   $0x0
80105094:	e8 77 f6 ff ff       	call   80104710 <argstr>
80105099:	83 c4 10             	add    $0x10,%esp
8010509c:	85 c0                	test   %eax,%eax
8010509e:	78 60                	js     80105100 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801050a0:	83 ec 08             	sub    $0x8,%esp
801050a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050a6:	50                   	push   %eax
801050a7:	6a 01                	push   $0x1
801050a9:	e8 a2 f5 ff ff       	call   80104650 <argint>
  if((argstr(0, &path)) < 0 ||
801050ae:	83 c4 10             	add    $0x10,%esp
801050b1:	85 c0                	test   %eax,%eax
801050b3:	78 4b                	js     80105100 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801050b5:	83 ec 08             	sub    $0x8,%esp
801050b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050bb:	50                   	push   %eax
801050bc:	6a 02                	push   $0x2
801050be:	e8 8d f5 ff ff       	call   80104650 <argint>
     argint(1, &major) < 0 ||
801050c3:	83 c4 10             	add    $0x10,%esp
801050c6:	85 c0                	test   %eax,%eax
801050c8:	78 36                	js     80105100 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801050ca:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801050ce:	83 ec 0c             	sub    $0xc,%esp
801050d1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801050d5:	ba 03 00 00 00       	mov    $0x3,%edx
801050da:	50                   	push   %eax
801050db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801050de:	e8 1d f7 ff ff       	call   80104800 <create>
     argint(2, &minor) < 0 ||
801050e3:	83 c4 10             	add    $0x10,%esp
801050e6:	85 c0                	test   %eax,%eax
801050e8:	74 16                	je     80105100 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801050ea:	83 ec 0c             	sub    $0xc,%esp
801050ed:	50                   	push   %eax
801050ee:	e8 3d c9 ff ff       	call   80101a30 <iunlockput>
  end_op();
801050f3:	e8 b8 d9 ff ff       	call   80102ab0 <end_op>
  return 0;
801050f8:	83 c4 10             	add    $0x10,%esp
801050fb:	31 c0                	xor    %eax,%eax
}
801050fd:	c9                   	leave
801050fe:	c3                   	ret
801050ff:	90                   	nop
    end_op();
80105100:	e8 ab d9 ff ff       	call   80102ab0 <end_op>
    return -1;
80105105:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010510a:	c9                   	leave
8010510b:	c3                   	ret
8010510c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105110 <sys_chdir>:

int
sys_chdir(void)
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	56                   	push   %esi
80105114:	53                   	push   %ebx
80105115:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105118:	e8 43 e5 ff ff       	call   80103660 <myproc>
8010511d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010511f:	e8 1c d9 ff ff       	call   80102a40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105124:	83 ec 08             	sub    $0x8,%esp
80105127:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010512a:	50                   	push   %eax
8010512b:	6a 00                	push   $0x0
8010512d:	e8 de f5 ff ff       	call   80104710 <argstr>
80105132:	83 c4 10             	add    $0x10,%esp
80105135:	85 c0                	test   %eax,%eax
80105137:	78 77                	js     801051b0 <sys_chdir+0xa0>
80105139:	83 ec 0c             	sub    $0xc,%esp
8010513c:	ff 75 f4             	push   -0xc(%ebp)
8010513f:	e8 3c cf ff ff       	call   80102080 <namei>
80105144:	83 c4 10             	add    $0x10,%esp
80105147:	89 c3                	mov    %eax,%ebx
80105149:	85 c0                	test   %eax,%eax
8010514b:	74 63                	je     801051b0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010514d:	83 ec 0c             	sub    $0xc,%esp
80105150:	50                   	push   %eax
80105151:	e8 4a c6 ff ff       	call   801017a0 <ilock>
  if(ip->type != T_DIR){
80105156:	83 c4 10             	add    $0x10,%esp
80105159:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010515e:	75 30                	jne    80105190 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105160:	83 ec 0c             	sub    $0xc,%esp
80105163:	53                   	push   %ebx
80105164:	e8 17 c7 ff ff       	call   80101880 <iunlock>
  iput(curproc->cwd);
80105169:	58                   	pop    %eax
8010516a:	ff 76 68             	push   0x68(%esi)
8010516d:	e8 5e c7 ff ff       	call   801018d0 <iput>
  end_op();
80105172:	e8 39 d9 ff ff       	call   80102ab0 <end_op>
  curproc->cwd = ip;
80105177:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010517a:	83 c4 10             	add    $0x10,%esp
8010517d:	31 c0                	xor    %eax,%eax
}
8010517f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105182:	5b                   	pop    %ebx
80105183:	5e                   	pop    %esi
80105184:	5d                   	pop    %ebp
80105185:	c3                   	ret
80105186:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010518d:	00 
8010518e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105190:	83 ec 0c             	sub    $0xc,%esp
80105193:	53                   	push   %ebx
80105194:	e8 97 c8 ff ff       	call   80101a30 <iunlockput>
    end_op();
80105199:	e8 12 d9 ff ff       	call   80102ab0 <end_op>
    return -1;
8010519e:	83 c4 10             	add    $0x10,%esp
    return -1;
801051a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051a6:	eb d7                	jmp    8010517f <sys_chdir+0x6f>
801051a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801051af:	00 
    end_op();
801051b0:	e8 fb d8 ff ff       	call   80102ab0 <end_op>
    return -1;
801051b5:	eb ea                	jmp    801051a1 <sys_chdir+0x91>
801051b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801051be:	00 
801051bf:	90                   	nop

801051c0 <sys_exec>:

int
sys_exec(void)
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	57                   	push   %edi
801051c4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801051c5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801051cb:	53                   	push   %ebx
801051cc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801051d2:	50                   	push   %eax
801051d3:	6a 00                	push   $0x0
801051d5:	e8 36 f5 ff ff       	call   80104710 <argstr>
801051da:	83 c4 10             	add    $0x10,%esp
801051dd:	85 c0                	test   %eax,%eax
801051df:	0f 88 87 00 00 00    	js     8010526c <sys_exec+0xac>
801051e5:	83 ec 08             	sub    $0x8,%esp
801051e8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801051ee:	50                   	push   %eax
801051ef:	6a 01                	push   $0x1
801051f1:	e8 5a f4 ff ff       	call   80104650 <argint>
801051f6:	83 c4 10             	add    $0x10,%esp
801051f9:	85 c0                	test   %eax,%eax
801051fb:	78 6f                	js     8010526c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801051fd:	83 ec 04             	sub    $0x4,%esp
80105200:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105206:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105208:	68 80 00 00 00       	push   $0x80
8010520d:	6a 00                	push   $0x0
8010520f:	56                   	push   %esi
80105210:	e8 8b f1 ff ff       	call   801043a0 <memset>
80105215:	83 c4 10             	add    $0x10,%esp
80105218:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010521f:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105220:	83 ec 08             	sub    $0x8,%esp
80105223:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105229:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105230:	50                   	push   %eax
80105231:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105237:	01 f8                	add    %edi,%eax
80105239:	50                   	push   %eax
8010523a:	e8 81 f3 ff ff       	call   801045c0 <fetchint>
8010523f:	83 c4 10             	add    $0x10,%esp
80105242:	85 c0                	test   %eax,%eax
80105244:	78 26                	js     8010526c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105246:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010524c:	85 c0                	test   %eax,%eax
8010524e:	74 30                	je     80105280 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105250:	83 ec 08             	sub    $0x8,%esp
80105253:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105256:	52                   	push   %edx
80105257:	50                   	push   %eax
80105258:	e8 a3 f3 ff ff       	call   80104600 <fetchstr>
8010525d:	83 c4 10             	add    $0x10,%esp
80105260:	85 c0                	test   %eax,%eax
80105262:	78 08                	js     8010526c <sys_exec+0xac>
  for(i=0;; i++){
80105264:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105267:	83 fb 20             	cmp    $0x20,%ebx
8010526a:	75 b4                	jne    80105220 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010526c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010526f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105274:	5b                   	pop    %ebx
80105275:	5e                   	pop    %esi
80105276:	5f                   	pop    %edi
80105277:	5d                   	pop    %ebp
80105278:	c3                   	ret
80105279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105280:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105287:	00 00 00 00 
  return exec(path, argv);
8010528b:	83 ec 08             	sub    $0x8,%esp
8010528e:	56                   	push   %esi
8010528f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105295:	e8 16 b8 ff ff       	call   80100ab0 <exec>
8010529a:	83 c4 10             	add    $0x10,%esp
}
8010529d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052a0:	5b                   	pop    %ebx
801052a1:	5e                   	pop    %esi
801052a2:	5f                   	pop    %edi
801052a3:	5d                   	pop    %ebp
801052a4:	c3                   	ret
801052a5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801052ac:	00 
801052ad:	8d 76 00             	lea    0x0(%esi),%esi

801052b0 <sys_pipe>:

int
sys_pipe(void)
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	57                   	push   %edi
801052b4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801052b5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801052b8:	53                   	push   %ebx
801052b9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801052bc:	6a 08                	push   $0x8
801052be:	50                   	push   %eax
801052bf:	6a 00                	push   $0x0
801052c1:	e8 da f3 ff ff       	call   801046a0 <argptr>
801052c6:	83 c4 10             	add    $0x10,%esp
801052c9:	85 c0                	test   %eax,%eax
801052cb:	0f 88 8b 00 00 00    	js     8010535c <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801052d1:	83 ec 08             	sub    $0x8,%esp
801052d4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801052d7:	50                   	push   %eax
801052d8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801052db:	50                   	push   %eax
801052dc:	e8 2f de ff ff       	call   80103110 <pipealloc>
801052e1:	83 c4 10             	add    $0x10,%esp
801052e4:	85 c0                	test   %eax,%eax
801052e6:	78 74                	js     8010535c <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801052e8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801052eb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801052ed:	e8 6e e3 ff ff       	call   80103660 <myproc>
    if(curproc->ofile[fd] == 0){
801052f2:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801052f6:	85 f6                	test   %esi,%esi
801052f8:	74 16                	je     80105310 <sys_pipe+0x60>
801052fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105300:	83 c3 01             	add    $0x1,%ebx
80105303:	83 fb 10             	cmp    $0x10,%ebx
80105306:	74 3d                	je     80105345 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
80105308:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010530c:	85 f6                	test   %esi,%esi
8010530e:	75 f0                	jne    80105300 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105310:	8d 73 08             	lea    0x8(%ebx),%esi
80105313:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105317:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010531a:	e8 41 e3 ff ff       	call   80103660 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010531f:	31 d2                	xor    %edx,%edx
80105321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105328:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010532c:	85 c9                	test   %ecx,%ecx
8010532e:	74 38                	je     80105368 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80105330:	83 c2 01             	add    $0x1,%edx
80105333:	83 fa 10             	cmp    $0x10,%edx
80105336:	75 f0                	jne    80105328 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105338:	e8 23 e3 ff ff       	call   80103660 <myproc>
8010533d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105344:	00 
    fileclose(rf);
80105345:	83 ec 0c             	sub    $0xc,%esp
80105348:	ff 75 e0             	push   -0x20(%ebp)
8010534b:	e8 c0 bb ff ff       	call   80100f10 <fileclose>
    fileclose(wf);
80105350:	58                   	pop    %eax
80105351:	ff 75 e4             	push   -0x1c(%ebp)
80105354:	e8 b7 bb ff ff       	call   80100f10 <fileclose>
    return -1;
80105359:	83 c4 10             	add    $0x10,%esp
    return -1;
8010535c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105361:	eb 16                	jmp    80105379 <sys_pipe+0xc9>
80105363:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80105368:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
8010536c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010536f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105371:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105374:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105377:	31 c0                	xor    %eax,%eax
}
80105379:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010537c:	5b                   	pop    %ebx
8010537d:	5e                   	pop    %esi
8010537e:	5f                   	pop    %edi
8010537f:	5d                   	pop    %ebp
80105380:	c3                   	ret
80105381:	66 90                	xchg   %ax,%ax
80105383:	66 90                	xchg   %ax,%ax
80105385:	66 90                	xchg   %ax,%ax
80105387:	66 90                	xchg   %ax,%ax
80105389:	66 90                	xchg   %ax,%ax
8010538b:	66 90                	xchg   %ax,%ax
8010538d:	66 90                	xchg   %ax,%ax
8010538f:	90                   	nop

80105390 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105390:	e9 6b e4 ff ff       	jmp    80103800 <fork>
80105395:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010539c:	00 
8010539d:	8d 76 00             	lea    0x0(%esi),%esi

801053a0 <sys_exit>:
}

int
sys_exit(void)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	83 ec 08             	sub    $0x8,%esp
  exit();
801053a6:	e8 c5 e6 ff ff       	call   80103a70 <exit>
  return 0;  // not reached
}
801053ab:	31 c0                	xor    %eax,%eax
801053ad:	c9                   	leave
801053ae:	c3                   	ret
801053af:	90                   	nop

801053b0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801053b0:	e9 eb e7 ff ff       	jmp    80103ba0 <wait>
801053b5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801053bc:	00 
801053bd:	8d 76 00             	lea    0x0(%esi),%esi

801053c0 <sys_kill>:
}

int
sys_kill(void)
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801053c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053c9:	50                   	push   %eax
801053ca:	6a 00                	push   $0x0
801053cc:	e8 7f f2 ff ff       	call   80104650 <argint>
801053d1:	83 c4 10             	add    $0x10,%esp
801053d4:	85 c0                	test   %eax,%eax
801053d6:	78 18                	js     801053f0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801053d8:	83 ec 0c             	sub    $0xc,%esp
801053db:	ff 75 f4             	push   -0xc(%ebp)
801053de:	e8 5d ea ff ff       	call   80103e40 <kill>
801053e3:	83 c4 10             	add    $0x10,%esp
}
801053e6:	c9                   	leave
801053e7:	c3                   	ret
801053e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801053ef:	00 
801053f0:	c9                   	leave
    return -1;
801053f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053f6:	c3                   	ret
801053f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801053fe:	00 
801053ff:	90                   	nop

80105400 <sys_getpid>:

int
sys_getpid(void)
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105406:	e8 55 e2 ff ff       	call   80103660 <myproc>
8010540b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010540e:	c9                   	leave
8010540f:	c3                   	ret

80105410 <sys_sbrk>:

int
sys_sbrk(void)
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105414:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105417:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010541a:	50                   	push   %eax
8010541b:	6a 00                	push   $0x0
8010541d:	e8 2e f2 ff ff       	call   80104650 <argint>
80105422:	83 c4 10             	add    $0x10,%esp
80105425:	85 c0                	test   %eax,%eax
80105427:	78 27                	js     80105450 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105429:	e8 32 e2 ff ff       	call   80103660 <myproc>
  if(growproc(n) < 0)
8010542e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105431:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105433:	ff 75 f4             	push   -0xc(%ebp)
80105436:	e8 45 e3 ff ff       	call   80103780 <growproc>
8010543b:	83 c4 10             	add    $0x10,%esp
8010543e:	85 c0                	test   %eax,%eax
80105440:	78 0e                	js     80105450 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105442:	89 d8                	mov    %ebx,%eax
80105444:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105447:	c9                   	leave
80105448:	c3                   	ret
80105449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105450:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105455:	eb eb                	jmp    80105442 <sys_sbrk+0x32>
80105457:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010545e:	00 
8010545f:	90                   	nop

80105460 <sys_sleep>:

int
sys_sleep(void)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105464:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105467:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010546a:	50                   	push   %eax
8010546b:	6a 00                	push   $0x0
8010546d:	e8 de f1 ff ff       	call   80104650 <argint>
80105472:	83 c4 10             	add    $0x10,%esp
80105475:	85 c0                	test   %eax,%eax
80105477:	78 64                	js     801054dd <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105479:	83 ec 0c             	sub    $0xc,%esp
8010547c:	68 20 0c 19 80       	push   $0x80190c20
80105481:	e8 1a ee ff ff       	call   801042a0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105486:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105489:	8b 1d 00 0c 19 80    	mov    0x80190c00,%ebx
  while(ticks - ticks0 < n){
8010548f:	83 c4 10             	add    $0x10,%esp
80105492:	85 d2                	test   %edx,%edx
80105494:	75 2b                	jne    801054c1 <sys_sleep+0x61>
80105496:	eb 58                	jmp    801054f0 <sys_sleep+0x90>
80105498:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010549f:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801054a0:	83 ec 08             	sub    $0x8,%esp
801054a3:	68 20 0c 19 80       	push   $0x80190c20
801054a8:	68 00 0c 19 80       	push   $0x80190c00
801054ad:	e8 6e e8 ff ff       	call   80103d20 <sleep>
  while(ticks - ticks0 < n){
801054b2:	a1 00 0c 19 80       	mov    0x80190c00,%eax
801054b7:	83 c4 10             	add    $0x10,%esp
801054ba:	29 d8                	sub    %ebx,%eax
801054bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801054bf:	73 2f                	jae    801054f0 <sys_sleep+0x90>
    if(myproc()->killed){
801054c1:	e8 9a e1 ff ff       	call   80103660 <myproc>
801054c6:	8b 40 24             	mov    0x24(%eax),%eax
801054c9:	85 c0                	test   %eax,%eax
801054cb:	74 d3                	je     801054a0 <sys_sleep+0x40>
      release(&tickslock);
801054cd:	83 ec 0c             	sub    $0xc,%esp
801054d0:	68 20 0c 19 80       	push   $0x80190c20
801054d5:	e8 66 ed ff ff       	call   80104240 <release>
      return -1;
801054da:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
801054dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
801054e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054e5:	c9                   	leave
801054e6:	c3                   	ret
801054e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801054ee:	00 
801054ef:	90                   	nop
  release(&tickslock);
801054f0:	83 ec 0c             	sub    $0xc,%esp
801054f3:	68 20 0c 19 80       	push   $0x80190c20
801054f8:	e8 43 ed ff ff       	call   80104240 <release>
}
801054fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80105500:	83 c4 10             	add    $0x10,%esp
80105503:	31 c0                	xor    %eax,%eax
}
80105505:	c9                   	leave
80105506:	c3                   	ret
80105507:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010550e:	00 
8010550f:	90                   	nop

80105510 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	53                   	push   %ebx
80105514:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105517:	68 20 0c 19 80       	push   $0x80190c20
8010551c:	e8 7f ed ff ff       	call   801042a0 <acquire>
  xticks = ticks;
80105521:	8b 1d 00 0c 19 80    	mov    0x80190c00,%ebx
  release(&tickslock);
80105527:	c7 04 24 20 0c 19 80 	movl   $0x80190c20,(%esp)
8010552e:	e8 0d ed ff ff       	call   80104240 <release>
  return xticks;
}
80105533:	89 d8                	mov    %ebx,%eax
80105535:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105538:	c9                   	leave
80105539:	c3                   	ret

8010553a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010553a:	1e                   	push   %ds
  pushl %es
8010553b:	06                   	push   %es
  pushl %fs
8010553c:	0f a0                	push   %fs
  pushl %gs
8010553e:	0f a8                	push   %gs
  pushal
80105540:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105541:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105545:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105547:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105549:	54                   	push   %esp
  call trap
8010554a:	e8 c1 00 00 00       	call   80105610 <trap>
  addl $4, %esp
8010554f:	83 c4 04             	add    $0x4,%esp

80105552 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105552:	61                   	popa
  popl %gs
80105553:	0f a9                	pop    %gs
  popl %fs
80105555:	0f a1                	pop    %fs
  popl %es
80105557:	07                   	pop    %es
  popl %ds
80105558:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105559:	83 c4 08             	add    $0x8,%esp
  iret
8010555c:	cf                   	iret
8010555d:	66 90                	xchg   %ax,%ax
8010555f:	90                   	nop

80105560 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105560:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105561:	31 c0                	xor    %eax,%eax
{
80105563:	89 e5                	mov    %esp,%ebp
80105565:	83 ec 08             	sub    $0x8,%esp
80105568:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010556f:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105570:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105577:	c7 04 c5 62 0c 19 80 	movl   $0x8e000008,-0x7fe6f39e(,%eax,8)
8010557e:	08 00 00 8e 
80105582:	66 89 14 c5 60 0c 19 	mov    %dx,-0x7fe6f3a0(,%eax,8)
80105589:	80 
8010558a:	c1 ea 10             	shr    $0x10,%edx
8010558d:	66 89 14 c5 66 0c 19 	mov    %dx,-0x7fe6f39a(,%eax,8)
80105594:	80 
  for(i = 0; i < 256; i++)
80105595:	83 c0 01             	add    $0x1,%eax
80105598:	3d 00 01 00 00       	cmp    $0x100,%eax
8010559d:	75 d1                	jne    80105570 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010559f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801055a2:	a1 08 a1 10 80       	mov    0x8010a108,%eax
801055a7:	c7 05 62 0e 19 80 08 	movl   $0xef000008,0x80190e62
801055ae:	00 00 ef 
  initlock(&tickslock, "time");
801055b1:	68 e6 72 10 80       	push   $0x801072e6
801055b6:	68 20 0c 19 80       	push   $0x80190c20
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801055bb:	66 a3 60 0e 19 80    	mov    %ax,0x80190e60
801055c1:	c1 e8 10             	shr    $0x10,%eax
801055c4:	66 a3 66 0e 19 80    	mov    %ax,0x80190e66
  initlock(&tickslock, "time");
801055ca:	e8 e1 ea ff ff       	call   801040b0 <initlock>
}
801055cf:	83 c4 10             	add    $0x10,%esp
801055d2:	c9                   	leave
801055d3:	c3                   	ret
801055d4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801055db:	00 
801055dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055e0 <idtinit>:

void
idtinit(void)
{
801055e0:	55                   	push   %ebp
  pd[0] = size-1;
801055e1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801055e6:	89 e5                	mov    %esp,%ebp
801055e8:	83 ec 10             	sub    $0x10,%esp
801055eb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801055ef:	b8 60 0c 19 80       	mov    $0x80190c60,%eax
801055f4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801055f8:	c1 e8 10             	shr    $0x10,%eax
801055fb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801055ff:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105602:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105605:	c9                   	leave
80105606:	c3                   	ret
80105607:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010560e:	00 
8010560f:	90                   	nop

80105610 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	57                   	push   %edi
80105614:	56                   	push   %esi
80105615:	53                   	push   %ebx
80105616:	83 ec 1c             	sub    $0x1c,%esp
80105619:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010561c:	8b 43 30             	mov    0x30(%ebx),%eax
8010561f:	83 f8 40             	cmp    $0x40,%eax
80105622:	0f 84 58 01 00 00    	je     80105780 <trap+0x170>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105628:	83 e8 20             	sub    $0x20,%eax
8010562b:	83 f8 1f             	cmp    $0x1f,%eax
8010562e:	0f 87 7c 00 00 00    	ja     801056b0 <trap+0xa0>
80105634:	ff 24 85 98 78 10 80 	jmp    *-0x7fef8768(,%eax,4)
8010563b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105640:	e8 3b 18 00 00       	call   80106e80 <ideintr>
    lapiceoi();
80105645:	e8 a6 cf ff ff       	call   801025f0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010564a:	e8 11 e0 ff ff       	call   80103660 <myproc>
8010564f:	85 c0                	test   %eax,%eax
80105651:	74 1a                	je     8010566d <trap+0x5d>
80105653:	e8 08 e0 ff ff       	call   80103660 <myproc>
80105658:	8b 50 24             	mov    0x24(%eax),%edx
8010565b:	85 d2                	test   %edx,%edx
8010565d:	74 0e                	je     8010566d <trap+0x5d>
8010565f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105663:	f7 d0                	not    %eax
80105665:	a8 03                	test   $0x3,%al
80105667:	0f 84 db 01 00 00    	je     80105848 <trap+0x238>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010566d:	e8 ee df ff ff       	call   80103660 <myproc>
80105672:	85 c0                	test   %eax,%eax
80105674:	74 0f                	je     80105685 <trap+0x75>
80105676:	e8 e5 df ff ff       	call   80103660 <myproc>
8010567b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010567f:	0f 84 ab 00 00 00    	je     80105730 <trap+0x120>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105685:	e8 d6 df ff ff       	call   80103660 <myproc>
8010568a:	85 c0                	test   %eax,%eax
8010568c:	74 1a                	je     801056a8 <trap+0x98>
8010568e:	e8 cd df ff ff       	call   80103660 <myproc>
80105693:	8b 40 24             	mov    0x24(%eax),%eax
80105696:	85 c0                	test   %eax,%eax
80105698:	74 0e                	je     801056a8 <trap+0x98>
8010569a:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010569e:	f7 d0                	not    %eax
801056a0:	a8 03                	test   $0x3,%al
801056a2:	0f 84 05 01 00 00    	je     801057ad <trap+0x19d>
    exit();
}
801056a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056ab:	5b                   	pop    %ebx
801056ac:	5e                   	pop    %esi
801056ad:	5f                   	pop    %edi
801056ae:	5d                   	pop    %ebp
801056af:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
801056b0:	e8 ab df ff ff       	call   80103660 <myproc>
801056b5:	8b 7b 38             	mov    0x38(%ebx),%edi
801056b8:	85 c0                	test   %eax,%eax
801056ba:	0f 84 a2 01 00 00    	je     80105862 <trap+0x252>
801056c0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801056c4:	0f 84 98 01 00 00    	je     80105862 <trap+0x252>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801056ca:	0f 20 d1             	mov    %cr2,%ecx
801056cd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801056d0:	e8 6b df ff ff       	call   80103640 <cpuid>
801056d5:	8b 73 30             	mov    0x30(%ebx),%esi
801056d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
801056db:	8b 43 34             	mov    0x34(%ebx),%eax
801056de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
801056e1:	e8 7a df ff ff       	call   80103660 <myproc>
801056e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801056e9:	e8 72 df ff ff       	call   80103660 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801056ee:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801056f1:	51                   	push   %ecx
801056f2:	57                   	push   %edi
801056f3:	8b 55 dc             	mov    -0x24(%ebp),%edx
801056f6:	52                   	push   %edx
801056f7:	ff 75 e4             	push   -0x1c(%ebp)
801056fa:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801056fb:	8b 75 e0             	mov    -0x20(%ebp),%esi
801056fe:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105701:	56                   	push   %esi
80105702:	ff 70 10             	push   0x10(%eax)
80105705:	68 98 75 10 80       	push   $0x80107598
8010570a:	e8 a1 af ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
8010570f:	83 c4 20             	add    $0x20,%esp
80105712:	e8 49 df ff ff       	call   80103660 <myproc>
80105717:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010571e:	e8 3d df ff ff       	call   80103660 <myproc>
80105723:	85 c0                	test   %eax,%eax
80105725:	0f 85 28 ff ff ff    	jne    80105653 <trap+0x43>
8010572b:	e9 3d ff ff ff       	jmp    8010566d <trap+0x5d>
  if(myproc() && myproc()->state == RUNNING &&
80105730:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105734:	0f 85 4b ff ff ff    	jne    80105685 <trap+0x75>
    yield();
8010573a:	e8 91 e5 ff ff       	call   80103cd0 <yield>
8010573f:	e9 41 ff ff ff       	jmp    80105685 <trap+0x75>
80105744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105748:	8b 7b 38             	mov    0x38(%ebx),%edi
8010574b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010574f:	e8 ec de ff ff       	call   80103640 <cpuid>
80105754:	57                   	push   %edi
80105755:	56                   	push   %esi
80105756:	50                   	push   %eax
80105757:	68 40 75 10 80       	push   $0x80107540
8010575c:	e8 4f af ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105761:	e8 8a ce ff ff       	call   801025f0 <lapiceoi>
    break;
80105766:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105769:	e8 f2 de ff ff       	call   80103660 <myproc>
8010576e:	85 c0                	test   %eax,%eax
80105770:	0f 85 dd fe ff ff    	jne    80105653 <trap+0x43>
80105776:	e9 f2 fe ff ff       	jmp    8010566d <trap+0x5d>
8010577b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105780:	e8 db de ff ff       	call   80103660 <myproc>
80105785:	8b 70 24             	mov    0x24(%eax),%esi
80105788:	85 f6                	test   %esi,%esi
8010578a:	0f 85 c8 00 00 00    	jne    80105858 <trap+0x248>
    myproc()->tf = tf;
80105790:	e8 cb de ff ff       	call   80103660 <myproc>
80105795:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105798:	e8 f3 ef ff ff       	call   80104790 <syscall>
    if(myproc()->killed)
8010579d:	e8 be de ff ff       	call   80103660 <myproc>
801057a2:	8b 48 24             	mov    0x24(%eax),%ecx
801057a5:	85 c9                	test   %ecx,%ecx
801057a7:	0f 84 fb fe ff ff    	je     801056a8 <trap+0x98>
}
801057ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057b0:	5b                   	pop    %ebx
801057b1:	5e                   	pop    %esi
801057b2:	5f                   	pop    %edi
801057b3:	5d                   	pop    %ebp
      exit();
801057b4:	e9 b7 e2 ff ff       	jmp    80103a70 <exit>
801057b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
801057c0:	e8 4b 02 00 00       	call   80105a10 <uartintr>
    lapiceoi();
801057c5:	e8 26 ce ff ff       	call   801025f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801057ca:	e8 91 de ff ff       	call   80103660 <myproc>
801057cf:	85 c0                	test   %eax,%eax
801057d1:	0f 85 7c fe ff ff    	jne    80105653 <trap+0x43>
801057d7:	e9 91 fe ff ff       	jmp    8010566d <trap+0x5d>
801057dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801057e0:	e8 db cc ff ff       	call   801024c0 <kbdintr>
    lapiceoi();
801057e5:	e8 06 ce ff ff       	call   801025f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801057ea:	e8 71 de ff ff       	call   80103660 <myproc>
801057ef:	85 c0                	test   %eax,%eax
801057f1:	0f 85 5c fe ff ff    	jne    80105653 <trap+0x43>
801057f7:	e9 71 fe ff ff       	jmp    8010566d <trap+0x5d>
801057fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105800:	e8 3b de ff ff       	call   80103640 <cpuid>
80105805:	85 c0                	test   %eax,%eax
80105807:	0f 85 38 fe ff ff    	jne    80105645 <trap+0x35>
      acquire(&tickslock);
8010580d:	83 ec 0c             	sub    $0xc,%esp
80105810:	68 20 0c 19 80       	push   $0x80190c20
80105815:	e8 86 ea ff ff       	call   801042a0 <acquire>
      ticks++;
8010581a:	83 05 00 0c 19 80 01 	addl   $0x1,0x80190c00
      wakeup(&ticks);
80105821:	c7 04 24 00 0c 19 80 	movl   $0x80190c00,(%esp)
80105828:	e8 b3 e5 ff ff       	call   80103de0 <wakeup>
      release(&tickslock);
8010582d:	c7 04 24 20 0c 19 80 	movl   $0x80190c20,(%esp)
80105834:	e8 07 ea ff ff       	call   80104240 <release>
80105839:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010583c:	e9 04 fe ff ff       	jmp    80105645 <trap+0x35>
80105841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105848:	e8 23 e2 ff ff       	call   80103a70 <exit>
8010584d:	e9 1b fe ff ff       	jmp    8010566d <trap+0x5d>
80105852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105858:	e8 13 e2 ff ff       	call   80103a70 <exit>
8010585d:	e9 2e ff ff ff       	jmp    80105790 <trap+0x180>
80105862:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105865:	e8 d6 dd ff ff       	call   80103640 <cpuid>
8010586a:	83 ec 0c             	sub    $0xc,%esp
8010586d:	56                   	push   %esi
8010586e:	57                   	push   %edi
8010586f:	50                   	push   %eax
80105870:	ff 73 30             	push   0x30(%ebx)
80105873:	68 64 75 10 80       	push   $0x80107564
80105878:	e8 33 ae ff ff       	call   801006b0 <cprintf>
      panic("trap");
8010587d:	83 c4 14             	add    $0x14,%esp
80105880:	68 eb 72 10 80       	push   $0x801072eb
80105885:	e8 f6 aa ff ff       	call   80100380 <panic>
8010588a:	66 90                	xchg   %ax,%ax
8010588c:	66 90                	xchg   %ax,%ax
8010588e:	66 90                	xchg   %ax,%ax

80105890 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105890:	a1 60 14 19 80       	mov    0x80191460,%eax
80105895:	85 c0                	test   %eax,%eax
80105897:	74 17                	je     801058b0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105899:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010589e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010589f:	a8 01                	test   $0x1,%al
801058a1:	74 0d                	je     801058b0 <uartgetc+0x20>
801058a3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801058a8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801058a9:	0f b6 c0             	movzbl %al,%eax
801058ac:	c3                   	ret
801058ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801058b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058b5:	c3                   	ret
801058b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801058bd:	00 
801058be:	66 90                	xchg   %ax,%ax

801058c0 <uartinit>:
{
801058c0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801058c1:	31 c9                	xor    %ecx,%ecx
801058c3:	89 c8                	mov    %ecx,%eax
801058c5:	89 e5                	mov    %esp,%ebp
801058c7:	57                   	push   %edi
801058c8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801058cd:	56                   	push   %esi
801058ce:	89 fa                	mov    %edi,%edx
801058d0:	53                   	push   %ebx
801058d1:	83 ec 1c             	sub    $0x1c,%esp
801058d4:	ee                   	out    %al,(%dx)
801058d5:	be fb 03 00 00       	mov    $0x3fb,%esi
801058da:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801058df:	89 f2                	mov    %esi,%edx
801058e1:	ee                   	out    %al,(%dx)
801058e2:	b8 0c 00 00 00       	mov    $0xc,%eax
801058e7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801058ec:	ee                   	out    %al,(%dx)
801058ed:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801058f2:	89 c8                	mov    %ecx,%eax
801058f4:	89 da                	mov    %ebx,%edx
801058f6:	ee                   	out    %al,(%dx)
801058f7:	b8 03 00 00 00       	mov    $0x3,%eax
801058fc:	89 f2                	mov    %esi,%edx
801058fe:	ee                   	out    %al,(%dx)
801058ff:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105904:	89 c8                	mov    %ecx,%eax
80105906:	ee                   	out    %al,(%dx)
80105907:	b8 01 00 00 00       	mov    $0x1,%eax
8010590c:	89 da                	mov    %ebx,%edx
8010590e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010590f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105914:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105915:	3c ff                	cmp    $0xff,%al
80105917:	0f 84 7c 00 00 00    	je     80105999 <uartinit+0xd9>
  uart = 1;
8010591d:	c7 05 60 14 19 80 01 	movl   $0x1,0x80191460
80105924:	00 00 00 
80105927:	89 fa                	mov    %edi,%edx
80105929:	ec                   	in     (%dx),%al
8010592a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010592f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105930:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105933:	bf f0 72 10 80       	mov    $0x801072f0,%edi
80105938:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
8010593d:	6a 00                	push   $0x0
8010593f:	6a 04                	push   $0x4
80105941:	e8 1a c8 ff ff       	call   80102160 <ioapicenable>
80105946:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105949:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
8010594d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80105950:	a1 60 14 19 80       	mov    0x80191460,%eax
80105955:	85 c0                	test   %eax,%eax
80105957:	74 32                	je     8010598b <uartinit+0xcb>
80105959:	89 f2                	mov    %esi,%edx
8010595b:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010595c:	a8 20                	test   $0x20,%al
8010595e:	75 21                	jne    80105981 <uartinit+0xc1>
80105960:	bb 80 00 00 00       	mov    $0x80,%ebx
80105965:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105968:	83 ec 0c             	sub    $0xc,%esp
8010596b:	6a 0a                	push   $0xa
8010596d:	e8 9e cc ff ff       	call   80102610 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105972:	83 c4 10             	add    $0x10,%esp
80105975:	83 eb 01             	sub    $0x1,%ebx
80105978:	74 07                	je     80105981 <uartinit+0xc1>
8010597a:	89 f2                	mov    %esi,%edx
8010597c:	ec                   	in     (%dx),%al
8010597d:	a8 20                	test   $0x20,%al
8010597f:	74 e7                	je     80105968 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105981:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105986:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010598a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
8010598b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
8010598f:	83 c7 01             	add    $0x1,%edi
80105992:	88 45 e7             	mov    %al,-0x19(%ebp)
80105995:	84 c0                	test   %al,%al
80105997:	75 b7                	jne    80105950 <uartinit+0x90>
}
80105999:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010599c:	5b                   	pop    %ebx
8010599d:	5e                   	pop    %esi
8010599e:	5f                   	pop    %edi
8010599f:	5d                   	pop    %ebp
801059a0:	c3                   	ret
801059a1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059a8:	00 
801059a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059b0 <uartputc>:
  if(!uart)
801059b0:	a1 60 14 19 80       	mov    0x80191460,%eax
801059b5:	85 c0                	test   %eax,%eax
801059b7:	74 4f                	je     80105a08 <uartputc+0x58>
{
801059b9:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801059ba:	ba fd 03 00 00       	mov    $0x3fd,%edx
801059bf:	89 e5                	mov    %esp,%ebp
801059c1:	56                   	push   %esi
801059c2:	53                   	push   %ebx
801059c3:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801059c4:	a8 20                	test   $0x20,%al
801059c6:	75 29                	jne    801059f1 <uartputc+0x41>
801059c8:	bb 80 00 00 00       	mov    $0x80,%ebx
801059cd:	be fd 03 00 00       	mov    $0x3fd,%esi
801059d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801059d8:	83 ec 0c             	sub    $0xc,%esp
801059db:	6a 0a                	push   $0xa
801059dd:	e8 2e cc ff ff       	call   80102610 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801059e2:	83 c4 10             	add    $0x10,%esp
801059e5:	83 eb 01             	sub    $0x1,%ebx
801059e8:	74 07                	je     801059f1 <uartputc+0x41>
801059ea:	89 f2                	mov    %esi,%edx
801059ec:	ec                   	in     (%dx),%al
801059ed:	a8 20                	test   $0x20,%al
801059ef:	74 e7                	je     801059d8 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801059f1:	8b 45 08             	mov    0x8(%ebp),%eax
801059f4:	ba f8 03 00 00       	mov    $0x3f8,%edx
801059f9:	ee                   	out    %al,(%dx)
}
801059fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801059fd:	5b                   	pop    %ebx
801059fe:	5e                   	pop    %esi
801059ff:	5d                   	pop    %ebp
80105a00:	c3                   	ret
80105a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a08:	c3                   	ret
80105a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a10 <uartintr>:

void
uartintr(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105a16:	68 90 58 10 80       	push   $0x80105890
80105a1b:	e8 80 ae ff ff       	call   801008a0 <consoleintr>
}
80105a20:	83 c4 10             	add    $0x10,%esp
80105a23:	c9                   	leave
80105a24:	c3                   	ret

80105a25 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105a25:	6a 00                	push   $0x0
  pushl $0
80105a27:	6a 00                	push   $0x0
  jmp alltraps
80105a29:	e9 0c fb ff ff       	jmp    8010553a <alltraps>

80105a2e <vector1>:
.globl vector1
vector1:
  pushl $0
80105a2e:	6a 00                	push   $0x0
  pushl $1
80105a30:	6a 01                	push   $0x1
  jmp alltraps
80105a32:	e9 03 fb ff ff       	jmp    8010553a <alltraps>

80105a37 <vector2>:
.globl vector2
vector2:
  pushl $0
80105a37:	6a 00                	push   $0x0
  pushl $2
80105a39:	6a 02                	push   $0x2
  jmp alltraps
80105a3b:	e9 fa fa ff ff       	jmp    8010553a <alltraps>

80105a40 <vector3>:
.globl vector3
vector3:
  pushl $0
80105a40:	6a 00                	push   $0x0
  pushl $3
80105a42:	6a 03                	push   $0x3
  jmp alltraps
80105a44:	e9 f1 fa ff ff       	jmp    8010553a <alltraps>

80105a49 <vector4>:
.globl vector4
vector4:
  pushl $0
80105a49:	6a 00                	push   $0x0
  pushl $4
80105a4b:	6a 04                	push   $0x4
  jmp alltraps
80105a4d:	e9 e8 fa ff ff       	jmp    8010553a <alltraps>

80105a52 <vector5>:
.globl vector5
vector5:
  pushl $0
80105a52:	6a 00                	push   $0x0
  pushl $5
80105a54:	6a 05                	push   $0x5
  jmp alltraps
80105a56:	e9 df fa ff ff       	jmp    8010553a <alltraps>

80105a5b <vector6>:
.globl vector6
vector6:
  pushl $0
80105a5b:	6a 00                	push   $0x0
  pushl $6
80105a5d:	6a 06                	push   $0x6
  jmp alltraps
80105a5f:	e9 d6 fa ff ff       	jmp    8010553a <alltraps>

80105a64 <vector7>:
.globl vector7
vector7:
  pushl $0
80105a64:	6a 00                	push   $0x0
  pushl $7
80105a66:	6a 07                	push   $0x7
  jmp alltraps
80105a68:	e9 cd fa ff ff       	jmp    8010553a <alltraps>

80105a6d <vector8>:
.globl vector8
vector8:
  pushl $8
80105a6d:	6a 08                	push   $0x8
  jmp alltraps
80105a6f:	e9 c6 fa ff ff       	jmp    8010553a <alltraps>

80105a74 <vector9>:
.globl vector9
vector9:
  pushl $0
80105a74:	6a 00                	push   $0x0
  pushl $9
80105a76:	6a 09                	push   $0x9
  jmp alltraps
80105a78:	e9 bd fa ff ff       	jmp    8010553a <alltraps>

80105a7d <vector10>:
.globl vector10
vector10:
  pushl $10
80105a7d:	6a 0a                	push   $0xa
  jmp alltraps
80105a7f:	e9 b6 fa ff ff       	jmp    8010553a <alltraps>

80105a84 <vector11>:
.globl vector11
vector11:
  pushl $11
80105a84:	6a 0b                	push   $0xb
  jmp alltraps
80105a86:	e9 af fa ff ff       	jmp    8010553a <alltraps>

80105a8b <vector12>:
.globl vector12
vector12:
  pushl $12
80105a8b:	6a 0c                	push   $0xc
  jmp alltraps
80105a8d:	e9 a8 fa ff ff       	jmp    8010553a <alltraps>

80105a92 <vector13>:
.globl vector13
vector13:
  pushl $13
80105a92:	6a 0d                	push   $0xd
  jmp alltraps
80105a94:	e9 a1 fa ff ff       	jmp    8010553a <alltraps>

80105a99 <vector14>:
.globl vector14
vector14:
  pushl $14
80105a99:	6a 0e                	push   $0xe
  jmp alltraps
80105a9b:	e9 9a fa ff ff       	jmp    8010553a <alltraps>

80105aa0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105aa0:	6a 00                	push   $0x0
  pushl $15
80105aa2:	6a 0f                	push   $0xf
  jmp alltraps
80105aa4:	e9 91 fa ff ff       	jmp    8010553a <alltraps>

80105aa9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105aa9:	6a 00                	push   $0x0
  pushl $16
80105aab:	6a 10                	push   $0x10
  jmp alltraps
80105aad:	e9 88 fa ff ff       	jmp    8010553a <alltraps>

80105ab2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105ab2:	6a 11                	push   $0x11
  jmp alltraps
80105ab4:	e9 81 fa ff ff       	jmp    8010553a <alltraps>

80105ab9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105ab9:	6a 00                	push   $0x0
  pushl $18
80105abb:	6a 12                	push   $0x12
  jmp alltraps
80105abd:	e9 78 fa ff ff       	jmp    8010553a <alltraps>

80105ac2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105ac2:	6a 00                	push   $0x0
  pushl $19
80105ac4:	6a 13                	push   $0x13
  jmp alltraps
80105ac6:	e9 6f fa ff ff       	jmp    8010553a <alltraps>

80105acb <vector20>:
.globl vector20
vector20:
  pushl $0
80105acb:	6a 00                	push   $0x0
  pushl $20
80105acd:	6a 14                	push   $0x14
  jmp alltraps
80105acf:	e9 66 fa ff ff       	jmp    8010553a <alltraps>

80105ad4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105ad4:	6a 00                	push   $0x0
  pushl $21
80105ad6:	6a 15                	push   $0x15
  jmp alltraps
80105ad8:	e9 5d fa ff ff       	jmp    8010553a <alltraps>

80105add <vector22>:
.globl vector22
vector22:
  pushl $0
80105add:	6a 00                	push   $0x0
  pushl $22
80105adf:	6a 16                	push   $0x16
  jmp alltraps
80105ae1:	e9 54 fa ff ff       	jmp    8010553a <alltraps>

80105ae6 <vector23>:
.globl vector23
vector23:
  pushl $0
80105ae6:	6a 00                	push   $0x0
  pushl $23
80105ae8:	6a 17                	push   $0x17
  jmp alltraps
80105aea:	e9 4b fa ff ff       	jmp    8010553a <alltraps>

80105aef <vector24>:
.globl vector24
vector24:
  pushl $0
80105aef:	6a 00                	push   $0x0
  pushl $24
80105af1:	6a 18                	push   $0x18
  jmp alltraps
80105af3:	e9 42 fa ff ff       	jmp    8010553a <alltraps>

80105af8 <vector25>:
.globl vector25
vector25:
  pushl $0
80105af8:	6a 00                	push   $0x0
  pushl $25
80105afa:	6a 19                	push   $0x19
  jmp alltraps
80105afc:	e9 39 fa ff ff       	jmp    8010553a <alltraps>

80105b01 <vector26>:
.globl vector26
vector26:
  pushl $0
80105b01:	6a 00                	push   $0x0
  pushl $26
80105b03:	6a 1a                	push   $0x1a
  jmp alltraps
80105b05:	e9 30 fa ff ff       	jmp    8010553a <alltraps>

80105b0a <vector27>:
.globl vector27
vector27:
  pushl $0
80105b0a:	6a 00                	push   $0x0
  pushl $27
80105b0c:	6a 1b                	push   $0x1b
  jmp alltraps
80105b0e:	e9 27 fa ff ff       	jmp    8010553a <alltraps>

80105b13 <vector28>:
.globl vector28
vector28:
  pushl $0
80105b13:	6a 00                	push   $0x0
  pushl $28
80105b15:	6a 1c                	push   $0x1c
  jmp alltraps
80105b17:	e9 1e fa ff ff       	jmp    8010553a <alltraps>

80105b1c <vector29>:
.globl vector29
vector29:
  pushl $0
80105b1c:	6a 00                	push   $0x0
  pushl $29
80105b1e:	6a 1d                	push   $0x1d
  jmp alltraps
80105b20:	e9 15 fa ff ff       	jmp    8010553a <alltraps>

80105b25 <vector30>:
.globl vector30
vector30:
  pushl $0
80105b25:	6a 00                	push   $0x0
  pushl $30
80105b27:	6a 1e                	push   $0x1e
  jmp alltraps
80105b29:	e9 0c fa ff ff       	jmp    8010553a <alltraps>

80105b2e <vector31>:
.globl vector31
vector31:
  pushl $0
80105b2e:	6a 00                	push   $0x0
  pushl $31
80105b30:	6a 1f                	push   $0x1f
  jmp alltraps
80105b32:	e9 03 fa ff ff       	jmp    8010553a <alltraps>

80105b37 <vector32>:
.globl vector32
vector32:
  pushl $0
80105b37:	6a 00                	push   $0x0
  pushl $32
80105b39:	6a 20                	push   $0x20
  jmp alltraps
80105b3b:	e9 fa f9 ff ff       	jmp    8010553a <alltraps>

80105b40 <vector33>:
.globl vector33
vector33:
  pushl $0
80105b40:	6a 00                	push   $0x0
  pushl $33
80105b42:	6a 21                	push   $0x21
  jmp alltraps
80105b44:	e9 f1 f9 ff ff       	jmp    8010553a <alltraps>

80105b49 <vector34>:
.globl vector34
vector34:
  pushl $0
80105b49:	6a 00                	push   $0x0
  pushl $34
80105b4b:	6a 22                	push   $0x22
  jmp alltraps
80105b4d:	e9 e8 f9 ff ff       	jmp    8010553a <alltraps>

80105b52 <vector35>:
.globl vector35
vector35:
  pushl $0
80105b52:	6a 00                	push   $0x0
  pushl $35
80105b54:	6a 23                	push   $0x23
  jmp alltraps
80105b56:	e9 df f9 ff ff       	jmp    8010553a <alltraps>

80105b5b <vector36>:
.globl vector36
vector36:
  pushl $0
80105b5b:	6a 00                	push   $0x0
  pushl $36
80105b5d:	6a 24                	push   $0x24
  jmp alltraps
80105b5f:	e9 d6 f9 ff ff       	jmp    8010553a <alltraps>

80105b64 <vector37>:
.globl vector37
vector37:
  pushl $0
80105b64:	6a 00                	push   $0x0
  pushl $37
80105b66:	6a 25                	push   $0x25
  jmp alltraps
80105b68:	e9 cd f9 ff ff       	jmp    8010553a <alltraps>

80105b6d <vector38>:
.globl vector38
vector38:
  pushl $0
80105b6d:	6a 00                	push   $0x0
  pushl $38
80105b6f:	6a 26                	push   $0x26
  jmp alltraps
80105b71:	e9 c4 f9 ff ff       	jmp    8010553a <alltraps>

80105b76 <vector39>:
.globl vector39
vector39:
  pushl $0
80105b76:	6a 00                	push   $0x0
  pushl $39
80105b78:	6a 27                	push   $0x27
  jmp alltraps
80105b7a:	e9 bb f9 ff ff       	jmp    8010553a <alltraps>

80105b7f <vector40>:
.globl vector40
vector40:
  pushl $0
80105b7f:	6a 00                	push   $0x0
  pushl $40
80105b81:	6a 28                	push   $0x28
  jmp alltraps
80105b83:	e9 b2 f9 ff ff       	jmp    8010553a <alltraps>

80105b88 <vector41>:
.globl vector41
vector41:
  pushl $0
80105b88:	6a 00                	push   $0x0
  pushl $41
80105b8a:	6a 29                	push   $0x29
  jmp alltraps
80105b8c:	e9 a9 f9 ff ff       	jmp    8010553a <alltraps>

80105b91 <vector42>:
.globl vector42
vector42:
  pushl $0
80105b91:	6a 00                	push   $0x0
  pushl $42
80105b93:	6a 2a                	push   $0x2a
  jmp alltraps
80105b95:	e9 a0 f9 ff ff       	jmp    8010553a <alltraps>

80105b9a <vector43>:
.globl vector43
vector43:
  pushl $0
80105b9a:	6a 00                	push   $0x0
  pushl $43
80105b9c:	6a 2b                	push   $0x2b
  jmp alltraps
80105b9e:	e9 97 f9 ff ff       	jmp    8010553a <alltraps>

80105ba3 <vector44>:
.globl vector44
vector44:
  pushl $0
80105ba3:	6a 00                	push   $0x0
  pushl $44
80105ba5:	6a 2c                	push   $0x2c
  jmp alltraps
80105ba7:	e9 8e f9 ff ff       	jmp    8010553a <alltraps>

80105bac <vector45>:
.globl vector45
vector45:
  pushl $0
80105bac:	6a 00                	push   $0x0
  pushl $45
80105bae:	6a 2d                	push   $0x2d
  jmp alltraps
80105bb0:	e9 85 f9 ff ff       	jmp    8010553a <alltraps>

80105bb5 <vector46>:
.globl vector46
vector46:
  pushl $0
80105bb5:	6a 00                	push   $0x0
  pushl $46
80105bb7:	6a 2e                	push   $0x2e
  jmp alltraps
80105bb9:	e9 7c f9 ff ff       	jmp    8010553a <alltraps>

80105bbe <vector47>:
.globl vector47
vector47:
  pushl $0
80105bbe:	6a 00                	push   $0x0
  pushl $47
80105bc0:	6a 2f                	push   $0x2f
  jmp alltraps
80105bc2:	e9 73 f9 ff ff       	jmp    8010553a <alltraps>

80105bc7 <vector48>:
.globl vector48
vector48:
  pushl $0
80105bc7:	6a 00                	push   $0x0
  pushl $48
80105bc9:	6a 30                	push   $0x30
  jmp alltraps
80105bcb:	e9 6a f9 ff ff       	jmp    8010553a <alltraps>

80105bd0 <vector49>:
.globl vector49
vector49:
  pushl $0
80105bd0:	6a 00                	push   $0x0
  pushl $49
80105bd2:	6a 31                	push   $0x31
  jmp alltraps
80105bd4:	e9 61 f9 ff ff       	jmp    8010553a <alltraps>

80105bd9 <vector50>:
.globl vector50
vector50:
  pushl $0
80105bd9:	6a 00                	push   $0x0
  pushl $50
80105bdb:	6a 32                	push   $0x32
  jmp alltraps
80105bdd:	e9 58 f9 ff ff       	jmp    8010553a <alltraps>

80105be2 <vector51>:
.globl vector51
vector51:
  pushl $0
80105be2:	6a 00                	push   $0x0
  pushl $51
80105be4:	6a 33                	push   $0x33
  jmp alltraps
80105be6:	e9 4f f9 ff ff       	jmp    8010553a <alltraps>

80105beb <vector52>:
.globl vector52
vector52:
  pushl $0
80105beb:	6a 00                	push   $0x0
  pushl $52
80105bed:	6a 34                	push   $0x34
  jmp alltraps
80105bef:	e9 46 f9 ff ff       	jmp    8010553a <alltraps>

80105bf4 <vector53>:
.globl vector53
vector53:
  pushl $0
80105bf4:	6a 00                	push   $0x0
  pushl $53
80105bf6:	6a 35                	push   $0x35
  jmp alltraps
80105bf8:	e9 3d f9 ff ff       	jmp    8010553a <alltraps>

80105bfd <vector54>:
.globl vector54
vector54:
  pushl $0
80105bfd:	6a 00                	push   $0x0
  pushl $54
80105bff:	6a 36                	push   $0x36
  jmp alltraps
80105c01:	e9 34 f9 ff ff       	jmp    8010553a <alltraps>

80105c06 <vector55>:
.globl vector55
vector55:
  pushl $0
80105c06:	6a 00                	push   $0x0
  pushl $55
80105c08:	6a 37                	push   $0x37
  jmp alltraps
80105c0a:	e9 2b f9 ff ff       	jmp    8010553a <alltraps>

80105c0f <vector56>:
.globl vector56
vector56:
  pushl $0
80105c0f:	6a 00                	push   $0x0
  pushl $56
80105c11:	6a 38                	push   $0x38
  jmp alltraps
80105c13:	e9 22 f9 ff ff       	jmp    8010553a <alltraps>

80105c18 <vector57>:
.globl vector57
vector57:
  pushl $0
80105c18:	6a 00                	push   $0x0
  pushl $57
80105c1a:	6a 39                	push   $0x39
  jmp alltraps
80105c1c:	e9 19 f9 ff ff       	jmp    8010553a <alltraps>

80105c21 <vector58>:
.globl vector58
vector58:
  pushl $0
80105c21:	6a 00                	push   $0x0
  pushl $58
80105c23:	6a 3a                	push   $0x3a
  jmp alltraps
80105c25:	e9 10 f9 ff ff       	jmp    8010553a <alltraps>

80105c2a <vector59>:
.globl vector59
vector59:
  pushl $0
80105c2a:	6a 00                	push   $0x0
  pushl $59
80105c2c:	6a 3b                	push   $0x3b
  jmp alltraps
80105c2e:	e9 07 f9 ff ff       	jmp    8010553a <alltraps>

80105c33 <vector60>:
.globl vector60
vector60:
  pushl $0
80105c33:	6a 00                	push   $0x0
  pushl $60
80105c35:	6a 3c                	push   $0x3c
  jmp alltraps
80105c37:	e9 fe f8 ff ff       	jmp    8010553a <alltraps>

80105c3c <vector61>:
.globl vector61
vector61:
  pushl $0
80105c3c:	6a 00                	push   $0x0
  pushl $61
80105c3e:	6a 3d                	push   $0x3d
  jmp alltraps
80105c40:	e9 f5 f8 ff ff       	jmp    8010553a <alltraps>

80105c45 <vector62>:
.globl vector62
vector62:
  pushl $0
80105c45:	6a 00                	push   $0x0
  pushl $62
80105c47:	6a 3e                	push   $0x3e
  jmp alltraps
80105c49:	e9 ec f8 ff ff       	jmp    8010553a <alltraps>

80105c4e <vector63>:
.globl vector63
vector63:
  pushl $0
80105c4e:	6a 00                	push   $0x0
  pushl $63
80105c50:	6a 3f                	push   $0x3f
  jmp alltraps
80105c52:	e9 e3 f8 ff ff       	jmp    8010553a <alltraps>

80105c57 <vector64>:
.globl vector64
vector64:
  pushl $0
80105c57:	6a 00                	push   $0x0
  pushl $64
80105c59:	6a 40                	push   $0x40
  jmp alltraps
80105c5b:	e9 da f8 ff ff       	jmp    8010553a <alltraps>

80105c60 <vector65>:
.globl vector65
vector65:
  pushl $0
80105c60:	6a 00                	push   $0x0
  pushl $65
80105c62:	6a 41                	push   $0x41
  jmp alltraps
80105c64:	e9 d1 f8 ff ff       	jmp    8010553a <alltraps>

80105c69 <vector66>:
.globl vector66
vector66:
  pushl $0
80105c69:	6a 00                	push   $0x0
  pushl $66
80105c6b:	6a 42                	push   $0x42
  jmp alltraps
80105c6d:	e9 c8 f8 ff ff       	jmp    8010553a <alltraps>

80105c72 <vector67>:
.globl vector67
vector67:
  pushl $0
80105c72:	6a 00                	push   $0x0
  pushl $67
80105c74:	6a 43                	push   $0x43
  jmp alltraps
80105c76:	e9 bf f8 ff ff       	jmp    8010553a <alltraps>

80105c7b <vector68>:
.globl vector68
vector68:
  pushl $0
80105c7b:	6a 00                	push   $0x0
  pushl $68
80105c7d:	6a 44                	push   $0x44
  jmp alltraps
80105c7f:	e9 b6 f8 ff ff       	jmp    8010553a <alltraps>

80105c84 <vector69>:
.globl vector69
vector69:
  pushl $0
80105c84:	6a 00                	push   $0x0
  pushl $69
80105c86:	6a 45                	push   $0x45
  jmp alltraps
80105c88:	e9 ad f8 ff ff       	jmp    8010553a <alltraps>

80105c8d <vector70>:
.globl vector70
vector70:
  pushl $0
80105c8d:	6a 00                	push   $0x0
  pushl $70
80105c8f:	6a 46                	push   $0x46
  jmp alltraps
80105c91:	e9 a4 f8 ff ff       	jmp    8010553a <alltraps>

80105c96 <vector71>:
.globl vector71
vector71:
  pushl $0
80105c96:	6a 00                	push   $0x0
  pushl $71
80105c98:	6a 47                	push   $0x47
  jmp alltraps
80105c9a:	e9 9b f8 ff ff       	jmp    8010553a <alltraps>

80105c9f <vector72>:
.globl vector72
vector72:
  pushl $0
80105c9f:	6a 00                	push   $0x0
  pushl $72
80105ca1:	6a 48                	push   $0x48
  jmp alltraps
80105ca3:	e9 92 f8 ff ff       	jmp    8010553a <alltraps>

80105ca8 <vector73>:
.globl vector73
vector73:
  pushl $0
80105ca8:	6a 00                	push   $0x0
  pushl $73
80105caa:	6a 49                	push   $0x49
  jmp alltraps
80105cac:	e9 89 f8 ff ff       	jmp    8010553a <alltraps>

80105cb1 <vector74>:
.globl vector74
vector74:
  pushl $0
80105cb1:	6a 00                	push   $0x0
  pushl $74
80105cb3:	6a 4a                	push   $0x4a
  jmp alltraps
80105cb5:	e9 80 f8 ff ff       	jmp    8010553a <alltraps>

80105cba <vector75>:
.globl vector75
vector75:
  pushl $0
80105cba:	6a 00                	push   $0x0
  pushl $75
80105cbc:	6a 4b                	push   $0x4b
  jmp alltraps
80105cbe:	e9 77 f8 ff ff       	jmp    8010553a <alltraps>

80105cc3 <vector76>:
.globl vector76
vector76:
  pushl $0
80105cc3:	6a 00                	push   $0x0
  pushl $76
80105cc5:	6a 4c                	push   $0x4c
  jmp alltraps
80105cc7:	e9 6e f8 ff ff       	jmp    8010553a <alltraps>

80105ccc <vector77>:
.globl vector77
vector77:
  pushl $0
80105ccc:	6a 00                	push   $0x0
  pushl $77
80105cce:	6a 4d                	push   $0x4d
  jmp alltraps
80105cd0:	e9 65 f8 ff ff       	jmp    8010553a <alltraps>

80105cd5 <vector78>:
.globl vector78
vector78:
  pushl $0
80105cd5:	6a 00                	push   $0x0
  pushl $78
80105cd7:	6a 4e                	push   $0x4e
  jmp alltraps
80105cd9:	e9 5c f8 ff ff       	jmp    8010553a <alltraps>

80105cde <vector79>:
.globl vector79
vector79:
  pushl $0
80105cde:	6a 00                	push   $0x0
  pushl $79
80105ce0:	6a 4f                	push   $0x4f
  jmp alltraps
80105ce2:	e9 53 f8 ff ff       	jmp    8010553a <alltraps>

80105ce7 <vector80>:
.globl vector80
vector80:
  pushl $0
80105ce7:	6a 00                	push   $0x0
  pushl $80
80105ce9:	6a 50                	push   $0x50
  jmp alltraps
80105ceb:	e9 4a f8 ff ff       	jmp    8010553a <alltraps>

80105cf0 <vector81>:
.globl vector81
vector81:
  pushl $0
80105cf0:	6a 00                	push   $0x0
  pushl $81
80105cf2:	6a 51                	push   $0x51
  jmp alltraps
80105cf4:	e9 41 f8 ff ff       	jmp    8010553a <alltraps>

80105cf9 <vector82>:
.globl vector82
vector82:
  pushl $0
80105cf9:	6a 00                	push   $0x0
  pushl $82
80105cfb:	6a 52                	push   $0x52
  jmp alltraps
80105cfd:	e9 38 f8 ff ff       	jmp    8010553a <alltraps>

80105d02 <vector83>:
.globl vector83
vector83:
  pushl $0
80105d02:	6a 00                	push   $0x0
  pushl $83
80105d04:	6a 53                	push   $0x53
  jmp alltraps
80105d06:	e9 2f f8 ff ff       	jmp    8010553a <alltraps>

80105d0b <vector84>:
.globl vector84
vector84:
  pushl $0
80105d0b:	6a 00                	push   $0x0
  pushl $84
80105d0d:	6a 54                	push   $0x54
  jmp alltraps
80105d0f:	e9 26 f8 ff ff       	jmp    8010553a <alltraps>

80105d14 <vector85>:
.globl vector85
vector85:
  pushl $0
80105d14:	6a 00                	push   $0x0
  pushl $85
80105d16:	6a 55                	push   $0x55
  jmp alltraps
80105d18:	e9 1d f8 ff ff       	jmp    8010553a <alltraps>

80105d1d <vector86>:
.globl vector86
vector86:
  pushl $0
80105d1d:	6a 00                	push   $0x0
  pushl $86
80105d1f:	6a 56                	push   $0x56
  jmp alltraps
80105d21:	e9 14 f8 ff ff       	jmp    8010553a <alltraps>

80105d26 <vector87>:
.globl vector87
vector87:
  pushl $0
80105d26:	6a 00                	push   $0x0
  pushl $87
80105d28:	6a 57                	push   $0x57
  jmp alltraps
80105d2a:	e9 0b f8 ff ff       	jmp    8010553a <alltraps>

80105d2f <vector88>:
.globl vector88
vector88:
  pushl $0
80105d2f:	6a 00                	push   $0x0
  pushl $88
80105d31:	6a 58                	push   $0x58
  jmp alltraps
80105d33:	e9 02 f8 ff ff       	jmp    8010553a <alltraps>

80105d38 <vector89>:
.globl vector89
vector89:
  pushl $0
80105d38:	6a 00                	push   $0x0
  pushl $89
80105d3a:	6a 59                	push   $0x59
  jmp alltraps
80105d3c:	e9 f9 f7 ff ff       	jmp    8010553a <alltraps>

80105d41 <vector90>:
.globl vector90
vector90:
  pushl $0
80105d41:	6a 00                	push   $0x0
  pushl $90
80105d43:	6a 5a                	push   $0x5a
  jmp alltraps
80105d45:	e9 f0 f7 ff ff       	jmp    8010553a <alltraps>

80105d4a <vector91>:
.globl vector91
vector91:
  pushl $0
80105d4a:	6a 00                	push   $0x0
  pushl $91
80105d4c:	6a 5b                	push   $0x5b
  jmp alltraps
80105d4e:	e9 e7 f7 ff ff       	jmp    8010553a <alltraps>

80105d53 <vector92>:
.globl vector92
vector92:
  pushl $0
80105d53:	6a 00                	push   $0x0
  pushl $92
80105d55:	6a 5c                	push   $0x5c
  jmp alltraps
80105d57:	e9 de f7 ff ff       	jmp    8010553a <alltraps>

80105d5c <vector93>:
.globl vector93
vector93:
  pushl $0
80105d5c:	6a 00                	push   $0x0
  pushl $93
80105d5e:	6a 5d                	push   $0x5d
  jmp alltraps
80105d60:	e9 d5 f7 ff ff       	jmp    8010553a <alltraps>

80105d65 <vector94>:
.globl vector94
vector94:
  pushl $0
80105d65:	6a 00                	push   $0x0
  pushl $94
80105d67:	6a 5e                	push   $0x5e
  jmp alltraps
80105d69:	e9 cc f7 ff ff       	jmp    8010553a <alltraps>

80105d6e <vector95>:
.globl vector95
vector95:
  pushl $0
80105d6e:	6a 00                	push   $0x0
  pushl $95
80105d70:	6a 5f                	push   $0x5f
  jmp alltraps
80105d72:	e9 c3 f7 ff ff       	jmp    8010553a <alltraps>

80105d77 <vector96>:
.globl vector96
vector96:
  pushl $0
80105d77:	6a 00                	push   $0x0
  pushl $96
80105d79:	6a 60                	push   $0x60
  jmp alltraps
80105d7b:	e9 ba f7 ff ff       	jmp    8010553a <alltraps>

80105d80 <vector97>:
.globl vector97
vector97:
  pushl $0
80105d80:	6a 00                	push   $0x0
  pushl $97
80105d82:	6a 61                	push   $0x61
  jmp alltraps
80105d84:	e9 b1 f7 ff ff       	jmp    8010553a <alltraps>

80105d89 <vector98>:
.globl vector98
vector98:
  pushl $0
80105d89:	6a 00                	push   $0x0
  pushl $98
80105d8b:	6a 62                	push   $0x62
  jmp alltraps
80105d8d:	e9 a8 f7 ff ff       	jmp    8010553a <alltraps>

80105d92 <vector99>:
.globl vector99
vector99:
  pushl $0
80105d92:	6a 00                	push   $0x0
  pushl $99
80105d94:	6a 63                	push   $0x63
  jmp alltraps
80105d96:	e9 9f f7 ff ff       	jmp    8010553a <alltraps>

80105d9b <vector100>:
.globl vector100
vector100:
  pushl $0
80105d9b:	6a 00                	push   $0x0
  pushl $100
80105d9d:	6a 64                	push   $0x64
  jmp alltraps
80105d9f:	e9 96 f7 ff ff       	jmp    8010553a <alltraps>

80105da4 <vector101>:
.globl vector101
vector101:
  pushl $0
80105da4:	6a 00                	push   $0x0
  pushl $101
80105da6:	6a 65                	push   $0x65
  jmp alltraps
80105da8:	e9 8d f7 ff ff       	jmp    8010553a <alltraps>

80105dad <vector102>:
.globl vector102
vector102:
  pushl $0
80105dad:	6a 00                	push   $0x0
  pushl $102
80105daf:	6a 66                	push   $0x66
  jmp alltraps
80105db1:	e9 84 f7 ff ff       	jmp    8010553a <alltraps>

80105db6 <vector103>:
.globl vector103
vector103:
  pushl $0
80105db6:	6a 00                	push   $0x0
  pushl $103
80105db8:	6a 67                	push   $0x67
  jmp alltraps
80105dba:	e9 7b f7 ff ff       	jmp    8010553a <alltraps>

80105dbf <vector104>:
.globl vector104
vector104:
  pushl $0
80105dbf:	6a 00                	push   $0x0
  pushl $104
80105dc1:	6a 68                	push   $0x68
  jmp alltraps
80105dc3:	e9 72 f7 ff ff       	jmp    8010553a <alltraps>

80105dc8 <vector105>:
.globl vector105
vector105:
  pushl $0
80105dc8:	6a 00                	push   $0x0
  pushl $105
80105dca:	6a 69                	push   $0x69
  jmp alltraps
80105dcc:	e9 69 f7 ff ff       	jmp    8010553a <alltraps>

80105dd1 <vector106>:
.globl vector106
vector106:
  pushl $0
80105dd1:	6a 00                	push   $0x0
  pushl $106
80105dd3:	6a 6a                	push   $0x6a
  jmp alltraps
80105dd5:	e9 60 f7 ff ff       	jmp    8010553a <alltraps>

80105dda <vector107>:
.globl vector107
vector107:
  pushl $0
80105dda:	6a 00                	push   $0x0
  pushl $107
80105ddc:	6a 6b                	push   $0x6b
  jmp alltraps
80105dde:	e9 57 f7 ff ff       	jmp    8010553a <alltraps>

80105de3 <vector108>:
.globl vector108
vector108:
  pushl $0
80105de3:	6a 00                	push   $0x0
  pushl $108
80105de5:	6a 6c                	push   $0x6c
  jmp alltraps
80105de7:	e9 4e f7 ff ff       	jmp    8010553a <alltraps>

80105dec <vector109>:
.globl vector109
vector109:
  pushl $0
80105dec:	6a 00                	push   $0x0
  pushl $109
80105dee:	6a 6d                	push   $0x6d
  jmp alltraps
80105df0:	e9 45 f7 ff ff       	jmp    8010553a <alltraps>

80105df5 <vector110>:
.globl vector110
vector110:
  pushl $0
80105df5:	6a 00                	push   $0x0
  pushl $110
80105df7:	6a 6e                	push   $0x6e
  jmp alltraps
80105df9:	e9 3c f7 ff ff       	jmp    8010553a <alltraps>

80105dfe <vector111>:
.globl vector111
vector111:
  pushl $0
80105dfe:	6a 00                	push   $0x0
  pushl $111
80105e00:	6a 6f                	push   $0x6f
  jmp alltraps
80105e02:	e9 33 f7 ff ff       	jmp    8010553a <alltraps>

80105e07 <vector112>:
.globl vector112
vector112:
  pushl $0
80105e07:	6a 00                	push   $0x0
  pushl $112
80105e09:	6a 70                	push   $0x70
  jmp alltraps
80105e0b:	e9 2a f7 ff ff       	jmp    8010553a <alltraps>

80105e10 <vector113>:
.globl vector113
vector113:
  pushl $0
80105e10:	6a 00                	push   $0x0
  pushl $113
80105e12:	6a 71                	push   $0x71
  jmp alltraps
80105e14:	e9 21 f7 ff ff       	jmp    8010553a <alltraps>

80105e19 <vector114>:
.globl vector114
vector114:
  pushl $0
80105e19:	6a 00                	push   $0x0
  pushl $114
80105e1b:	6a 72                	push   $0x72
  jmp alltraps
80105e1d:	e9 18 f7 ff ff       	jmp    8010553a <alltraps>

80105e22 <vector115>:
.globl vector115
vector115:
  pushl $0
80105e22:	6a 00                	push   $0x0
  pushl $115
80105e24:	6a 73                	push   $0x73
  jmp alltraps
80105e26:	e9 0f f7 ff ff       	jmp    8010553a <alltraps>

80105e2b <vector116>:
.globl vector116
vector116:
  pushl $0
80105e2b:	6a 00                	push   $0x0
  pushl $116
80105e2d:	6a 74                	push   $0x74
  jmp alltraps
80105e2f:	e9 06 f7 ff ff       	jmp    8010553a <alltraps>

80105e34 <vector117>:
.globl vector117
vector117:
  pushl $0
80105e34:	6a 00                	push   $0x0
  pushl $117
80105e36:	6a 75                	push   $0x75
  jmp alltraps
80105e38:	e9 fd f6 ff ff       	jmp    8010553a <alltraps>

80105e3d <vector118>:
.globl vector118
vector118:
  pushl $0
80105e3d:	6a 00                	push   $0x0
  pushl $118
80105e3f:	6a 76                	push   $0x76
  jmp alltraps
80105e41:	e9 f4 f6 ff ff       	jmp    8010553a <alltraps>

80105e46 <vector119>:
.globl vector119
vector119:
  pushl $0
80105e46:	6a 00                	push   $0x0
  pushl $119
80105e48:	6a 77                	push   $0x77
  jmp alltraps
80105e4a:	e9 eb f6 ff ff       	jmp    8010553a <alltraps>

80105e4f <vector120>:
.globl vector120
vector120:
  pushl $0
80105e4f:	6a 00                	push   $0x0
  pushl $120
80105e51:	6a 78                	push   $0x78
  jmp alltraps
80105e53:	e9 e2 f6 ff ff       	jmp    8010553a <alltraps>

80105e58 <vector121>:
.globl vector121
vector121:
  pushl $0
80105e58:	6a 00                	push   $0x0
  pushl $121
80105e5a:	6a 79                	push   $0x79
  jmp alltraps
80105e5c:	e9 d9 f6 ff ff       	jmp    8010553a <alltraps>

80105e61 <vector122>:
.globl vector122
vector122:
  pushl $0
80105e61:	6a 00                	push   $0x0
  pushl $122
80105e63:	6a 7a                	push   $0x7a
  jmp alltraps
80105e65:	e9 d0 f6 ff ff       	jmp    8010553a <alltraps>

80105e6a <vector123>:
.globl vector123
vector123:
  pushl $0
80105e6a:	6a 00                	push   $0x0
  pushl $123
80105e6c:	6a 7b                	push   $0x7b
  jmp alltraps
80105e6e:	e9 c7 f6 ff ff       	jmp    8010553a <alltraps>

80105e73 <vector124>:
.globl vector124
vector124:
  pushl $0
80105e73:	6a 00                	push   $0x0
  pushl $124
80105e75:	6a 7c                	push   $0x7c
  jmp alltraps
80105e77:	e9 be f6 ff ff       	jmp    8010553a <alltraps>

80105e7c <vector125>:
.globl vector125
vector125:
  pushl $0
80105e7c:	6a 00                	push   $0x0
  pushl $125
80105e7e:	6a 7d                	push   $0x7d
  jmp alltraps
80105e80:	e9 b5 f6 ff ff       	jmp    8010553a <alltraps>

80105e85 <vector126>:
.globl vector126
vector126:
  pushl $0
80105e85:	6a 00                	push   $0x0
  pushl $126
80105e87:	6a 7e                	push   $0x7e
  jmp alltraps
80105e89:	e9 ac f6 ff ff       	jmp    8010553a <alltraps>

80105e8e <vector127>:
.globl vector127
vector127:
  pushl $0
80105e8e:	6a 00                	push   $0x0
  pushl $127
80105e90:	6a 7f                	push   $0x7f
  jmp alltraps
80105e92:	e9 a3 f6 ff ff       	jmp    8010553a <alltraps>

80105e97 <vector128>:
.globl vector128
vector128:
  pushl $0
80105e97:	6a 00                	push   $0x0
  pushl $128
80105e99:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105e9e:	e9 97 f6 ff ff       	jmp    8010553a <alltraps>

80105ea3 <vector129>:
.globl vector129
vector129:
  pushl $0
80105ea3:	6a 00                	push   $0x0
  pushl $129
80105ea5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105eaa:	e9 8b f6 ff ff       	jmp    8010553a <alltraps>

80105eaf <vector130>:
.globl vector130
vector130:
  pushl $0
80105eaf:	6a 00                	push   $0x0
  pushl $130
80105eb1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105eb6:	e9 7f f6 ff ff       	jmp    8010553a <alltraps>

80105ebb <vector131>:
.globl vector131
vector131:
  pushl $0
80105ebb:	6a 00                	push   $0x0
  pushl $131
80105ebd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105ec2:	e9 73 f6 ff ff       	jmp    8010553a <alltraps>

80105ec7 <vector132>:
.globl vector132
vector132:
  pushl $0
80105ec7:	6a 00                	push   $0x0
  pushl $132
80105ec9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105ece:	e9 67 f6 ff ff       	jmp    8010553a <alltraps>

80105ed3 <vector133>:
.globl vector133
vector133:
  pushl $0
80105ed3:	6a 00                	push   $0x0
  pushl $133
80105ed5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105eda:	e9 5b f6 ff ff       	jmp    8010553a <alltraps>

80105edf <vector134>:
.globl vector134
vector134:
  pushl $0
80105edf:	6a 00                	push   $0x0
  pushl $134
80105ee1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105ee6:	e9 4f f6 ff ff       	jmp    8010553a <alltraps>

80105eeb <vector135>:
.globl vector135
vector135:
  pushl $0
80105eeb:	6a 00                	push   $0x0
  pushl $135
80105eed:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105ef2:	e9 43 f6 ff ff       	jmp    8010553a <alltraps>

80105ef7 <vector136>:
.globl vector136
vector136:
  pushl $0
80105ef7:	6a 00                	push   $0x0
  pushl $136
80105ef9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105efe:	e9 37 f6 ff ff       	jmp    8010553a <alltraps>

80105f03 <vector137>:
.globl vector137
vector137:
  pushl $0
80105f03:	6a 00                	push   $0x0
  pushl $137
80105f05:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105f0a:	e9 2b f6 ff ff       	jmp    8010553a <alltraps>

80105f0f <vector138>:
.globl vector138
vector138:
  pushl $0
80105f0f:	6a 00                	push   $0x0
  pushl $138
80105f11:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105f16:	e9 1f f6 ff ff       	jmp    8010553a <alltraps>

80105f1b <vector139>:
.globl vector139
vector139:
  pushl $0
80105f1b:	6a 00                	push   $0x0
  pushl $139
80105f1d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105f22:	e9 13 f6 ff ff       	jmp    8010553a <alltraps>

80105f27 <vector140>:
.globl vector140
vector140:
  pushl $0
80105f27:	6a 00                	push   $0x0
  pushl $140
80105f29:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105f2e:	e9 07 f6 ff ff       	jmp    8010553a <alltraps>

80105f33 <vector141>:
.globl vector141
vector141:
  pushl $0
80105f33:	6a 00                	push   $0x0
  pushl $141
80105f35:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105f3a:	e9 fb f5 ff ff       	jmp    8010553a <alltraps>

80105f3f <vector142>:
.globl vector142
vector142:
  pushl $0
80105f3f:	6a 00                	push   $0x0
  pushl $142
80105f41:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105f46:	e9 ef f5 ff ff       	jmp    8010553a <alltraps>

80105f4b <vector143>:
.globl vector143
vector143:
  pushl $0
80105f4b:	6a 00                	push   $0x0
  pushl $143
80105f4d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105f52:	e9 e3 f5 ff ff       	jmp    8010553a <alltraps>

80105f57 <vector144>:
.globl vector144
vector144:
  pushl $0
80105f57:	6a 00                	push   $0x0
  pushl $144
80105f59:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105f5e:	e9 d7 f5 ff ff       	jmp    8010553a <alltraps>

80105f63 <vector145>:
.globl vector145
vector145:
  pushl $0
80105f63:	6a 00                	push   $0x0
  pushl $145
80105f65:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105f6a:	e9 cb f5 ff ff       	jmp    8010553a <alltraps>

80105f6f <vector146>:
.globl vector146
vector146:
  pushl $0
80105f6f:	6a 00                	push   $0x0
  pushl $146
80105f71:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105f76:	e9 bf f5 ff ff       	jmp    8010553a <alltraps>

80105f7b <vector147>:
.globl vector147
vector147:
  pushl $0
80105f7b:	6a 00                	push   $0x0
  pushl $147
80105f7d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105f82:	e9 b3 f5 ff ff       	jmp    8010553a <alltraps>

80105f87 <vector148>:
.globl vector148
vector148:
  pushl $0
80105f87:	6a 00                	push   $0x0
  pushl $148
80105f89:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105f8e:	e9 a7 f5 ff ff       	jmp    8010553a <alltraps>

80105f93 <vector149>:
.globl vector149
vector149:
  pushl $0
80105f93:	6a 00                	push   $0x0
  pushl $149
80105f95:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105f9a:	e9 9b f5 ff ff       	jmp    8010553a <alltraps>

80105f9f <vector150>:
.globl vector150
vector150:
  pushl $0
80105f9f:	6a 00                	push   $0x0
  pushl $150
80105fa1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105fa6:	e9 8f f5 ff ff       	jmp    8010553a <alltraps>

80105fab <vector151>:
.globl vector151
vector151:
  pushl $0
80105fab:	6a 00                	push   $0x0
  pushl $151
80105fad:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105fb2:	e9 83 f5 ff ff       	jmp    8010553a <alltraps>

80105fb7 <vector152>:
.globl vector152
vector152:
  pushl $0
80105fb7:	6a 00                	push   $0x0
  pushl $152
80105fb9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105fbe:	e9 77 f5 ff ff       	jmp    8010553a <alltraps>

80105fc3 <vector153>:
.globl vector153
vector153:
  pushl $0
80105fc3:	6a 00                	push   $0x0
  pushl $153
80105fc5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105fca:	e9 6b f5 ff ff       	jmp    8010553a <alltraps>

80105fcf <vector154>:
.globl vector154
vector154:
  pushl $0
80105fcf:	6a 00                	push   $0x0
  pushl $154
80105fd1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105fd6:	e9 5f f5 ff ff       	jmp    8010553a <alltraps>

80105fdb <vector155>:
.globl vector155
vector155:
  pushl $0
80105fdb:	6a 00                	push   $0x0
  pushl $155
80105fdd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105fe2:	e9 53 f5 ff ff       	jmp    8010553a <alltraps>

80105fe7 <vector156>:
.globl vector156
vector156:
  pushl $0
80105fe7:	6a 00                	push   $0x0
  pushl $156
80105fe9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105fee:	e9 47 f5 ff ff       	jmp    8010553a <alltraps>

80105ff3 <vector157>:
.globl vector157
vector157:
  pushl $0
80105ff3:	6a 00                	push   $0x0
  pushl $157
80105ff5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105ffa:	e9 3b f5 ff ff       	jmp    8010553a <alltraps>

80105fff <vector158>:
.globl vector158
vector158:
  pushl $0
80105fff:	6a 00                	push   $0x0
  pushl $158
80106001:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106006:	e9 2f f5 ff ff       	jmp    8010553a <alltraps>

8010600b <vector159>:
.globl vector159
vector159:
  pushl $0
8010600b:	6a 00                	push   $0x0
  pushl $159
8010600d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106012:	e9 23 f5 ff ff       	jmp    8010553a <alltraps>

80106017 <vector160>:
.globl vector160
vector160:
  pushl $0
80106017:	6a 00                	push   $0x0
  pushl $160
80106019:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010601e:	e9 17 f5 ff ff       	jmp    8010553a <alltraps>

80106023 <vector161>:
.globl vector161
vector161:
  pushl $0
80106023:	6a 00                	push   $0x0
  pushl $161
80106025:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010602a:	e9 0b f5 ff ff       	jmp    8010553a <alltraps>

8010602f <vector162>:
.globl vector162
vector162:
  pushl $0
8010602f:	6a 00                	push   $0x0
  pushl $162
80106031:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106036:	e9 ff f4 ff ff       	jmp    8010553a <alltraps>

8010603b <vector163>:
.globl vector163
vector163:
  pushl $0
8010603b:	6a 00                	push   $0x0
  pushl $163
8010603d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106042:	e9 f3 f4 ff ff       	jmp    8010553a <alltraps>

80106047 <vector164>:
.globl vector164
vector164:
  pushl $0
80106047:	6a 00                	push   $0x0
  pushl $164
80106049:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010604e:	e9 e7 f4 ff ff       	jmp    8010553a <alltraps>

80106053 <vector165>:
.globl vector165
vector165:
  pushl $0
80106053:	6a 00                	push   $0x0
  pushl $165
80106055:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010605a:	e9 db f4 ff ff       	jmp    8010553a <alltraps>

8010605f <vector166>:
.globl vector166
vector166:
  pushl $0
8010605f:	6a 00                	push   $0x0
  pushl $166
80106061:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106066:	e9 cf f4 ff ff       	jmp    8010553a <alltraps>

8010606b <vector167>:
.globl vector167
vector167:
  pushl $0
8010606b:	6a 00                	push   $0x0
  pushl $167
8010606d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106072:	e9 c3 f4 ff ff       	jmp    8010553a <alltraps>

80106077 <vector168>:
.globl vector168
vector168:
  pushl $0
80106077:	6a 00                	push   $0x0
  pushl $168
80106079:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010607e:	e9 b7 f4 ff ff       	jmp    8010553a <alltraps>

80106083 <vector169>:
.globl vector169
vector169:
  pushl $0
80106083:	6a 00                	push   $0x0
  pushl $169
80106085:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010608a:	e9 ab f4 ff ff       	jmp    8010553a <alltraps>

8010608f <vector170>:
.globl vector170
vector170:
  pushl $0
8010608f:	6a 00                	push   $0x0
  pushl $170
80106091:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106096:	e9 9f f4 ff ff       	jmp    8010553a <alltraps>

8010609b <vector171>:
.globl vector171
vector171:
  pushl $0
8010609b:	6a 00                	push   $0x0
  pushl $171
8010609d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801060a2:	e9 93 f4 ff ff       	jmp    8010553a <alltraps>

801060a7 <vector172>:
.globl vector172
vector172:
  pushl $0
801060a7:	6a 00                	push   $0x0
  pushl $172
801060a9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801060ae:	e9 87 f4 ff ff       	jmp    8010553a <alltraps>

801060b3 <vector173>:
.globl vector173
vector173:
  pushl $0
801060b3:	6a 00                	push   $0x0
  pushl $173
801060b5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801060ba:	e9 7b f4 ff ff       	jmp    8010553a <alltraps>

801060bf <vector174>:
.globl vector174
vector174:
  pushl $0
801060bf:	6a 00                	push   $0x0
  pushl $174
801060c1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801060c6:	e9 6f f4 ff ff       	jmp    8010553a <alltraps>

801060cb <vector175>:
.globl vector175
vector175:
  pushl $0
801060cb:	6a 00                	push   $0x0
  pushl $175
801060cd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801060d2:	e9 63 f4 ff ff       	jmp    8010553a <alltraps>

801060d7 <vector176>:
.globl vector176
vector176:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $176
801060d9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801060de:	e9 57 f4 ff ff       	jmp    8010553a <alltraps>

801060e3 <vector177>:
.globl vector177
vector177:
  pushl $0
801060e3:	6a 00                	push   $0x0
  pushl $177
801060e5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801060ea:	e9 4b f4 ff ff       	jmp    8010553a <alltraps>

801060ef <vector178>:
.globl vector178
vector178:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $178
801060f1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801060f6:	e9 3f f4 ff ff       	jmp    8010553a <alltraps>

801060fb <vector179>:
.globl vector179
vector179:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $179
801060fd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106102:	e9 33 f4 ff ff       	jmp    8010553a <alltraps>

80106107 <vector180>:
.globl vector180
vector180:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $180
80106109:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010610e:	e9 27 f4 ff ff       	jmp    8010553a <alltraps>

80106113 <vector181>:
.globl vector181
vector181:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $181
80106115:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010611a:	e9 1b f4 ff ff       	jmp    8010553a <alltraps>

8010611f <vector182>:
.globl vector182
vector182:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $182
80106121:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106126:	e9 0f f4 ff ff       	jmp    8010553a <alltraps>

8010612b <vector183>:
.globl vector183
vector183:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $183
8010612d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106132:	e9 03 f4 ff ff       	jmp    8010553a <alltraps>

80106137 <vector184>:
.globl vector184
vector184:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $184
80106139:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010613e:	e9 f7 f3 ff ff       	jmp    8010553a <alltraps>

80106143 <vector185>:
.globl vector185
vector185:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $185
80106145:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010614a:	e9 eb f3 ff ff       	jmp    8010553a <alltraps>

8010614f <vector186>:
.globl vector186
vector186:
  pushl $0
8010614f:	6a 00                	push   $0x0
  pushl $186
80106151:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106156:	e9 df f3 ff ff       	jmp    8010553a <alltraps>

8010615b <vector187>:
.globl vector187
vector187:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $187
8010615d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106162:	e9 d3 f3 ff ff       	jmp    8010553a <alltraps>

80106167 <vector188>:
.globl vector188
vector188:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $188
80106169:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010616e:	e9 c7 f3 ff ff       	jmp    8010553a <alltraps>

80106173 <vector189>:
.globl vector189
vector189:
  pushl $0
80106173:	6a 00                	push   $0x0
  pushl $189
80106175:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010617a:	e9 bb f3 ff ff       	jmp    8010553a <alltraps>

8010617f <vector190>:
.globl vector190
vector190:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $190
80106181:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106186:	e9 af f3 ff ff       	jmp    8010553a <alltraps>

8010618b <vector191>:
.globl vector191
vector191:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $191
8010618d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106192:	e9 a3 f3 ff ff       	jmp    8010553a <alltraps>

80106197 <vector192>:
.globl vector192
vector192:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $192
80106199:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010619e:	e9 97 f3 ff ff       	jmp    8010553a <alltraps>

801061a3 <vector193>:
.globl vector193
vector193:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $193
801061a5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801061aa:	e9 8b f3 ff ff       	jmp    8010553a <alltraps>

801061af <vector194>:
.globl vector194
vector194:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $194
801061b1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801061b6:	e9 7f f3 ff ff       	jmp    8010553a <alltraps>

801061bb <vector195>:
.globl vector195
vector195:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $195
801061bd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801061c2:	e9 73 f3 ff ff       	jmp    8010553a <alltraps>

801061c7 <vector196>:
.globl vector196
vector196:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $196
801061c9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801061ce:	e9 67 f3 ff ff       	jmp    8010553a <alltraps>

801061d3 <vector197>:
.globl vector197
vector197:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $197
801061d5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801061da:	e9 5b f3 ff ff       	jmp    8010553a <alltraps>

801061df <vector198>:
.globl vector198
vector198:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $198
801061e1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801061e6:	e9 4f f3 ff ff       	jmp    8010553a <alltraps>

801061eb <vector199>:
.globl vector199
vector199:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $199
801061ed:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801061f2:	e9 43 f3 ff ff       	jmp    8010553a <alltraps>

801061f7 <vector200>:
.globl vector200
vector200:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $200
801061f9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801061fe:	e9 37 f3 ff ff       	jmp    8010553a <alltraps>

80106203 <vector201>:
.globl vector201
vector201:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $201
80106205:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010620a:	e9 2b f3 ff ff       	jmp    8010553a <alltraps>

8010620f <vector202>:
.globl vector202
vector202:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $202
80106211:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106216:	e9 1f f3 ff ff       	jmp    8010553a <alltraps>

8010621b <vector203>:
.globl vector203
vector203:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $203
8010621d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106222:	e9 13 f3 ff ff       	jmp    8010553a <alltraps>

80106227 <vector204>:
.globl vector204
vector204:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $204
80106229:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010622e:	e9 07 f3 ff ff       	jmp    8010553a <alltraps>

80106233 <vector205>:
.globl vector205
vector205:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $205
80106235:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010623a:	e9 fb f2 ff ff       	jmp    8010553a <alltraps>

8010623f <vector206>:
.globl vector206
vector206:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $206
80106241:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106246:	e9 ef f2 ff ff       	jmp    8010553a <alltraps>

8010624b <vector207>:
.globl vector207
vector207:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $207
8010624d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106252:	e9 e3 f2 ff ff       	jmp    8010553a <alltraps>

80106257 <vector208>:
.globl vector208
vector208:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $208
80106259:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010625e:	e9 d7 f2 ff ff       	jmp    8010553a <alltraps>

80106263 <vector209>:
.globl vector209
vector209:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $209
80106265:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010626a:	e9 cb f2 ff ff       	jmp    8010553a <alltraps>

8010626f <vector210>:
.globl vector210
vector210:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $210
80106271:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106276:	e9 bf f2 ff ff       	jmp    8010553a <alltraps>

8010627b <vector211>:
.globl vector211
vector211:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $211
8010627d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106282:	e9 b3 f2 ff ff       	jmp    8010553a <alltraps>

80106287 <vector212>:
.globl vector212
vector212:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $212
80106289:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010628e:	e9 a7 f2 ff ff       	jmp    8010553a <alltraps>

80106293 <vector213>:
.globl vector213
vector213:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $213
80106295:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010629a:	e9 9b f2 ff ff       	jmp    8010553a <alltraps>

8010629f <vector214>:
.globl vector214
vector214:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $214
801062a1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801062a6:	e9 8f f2 ff ff       	jmp    8010553a <alltraps>

801062ab <vector215>:
.globl vector215
vector215:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $215
801062ad:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801062b2:	e9 83 f2 ff ff       	jmp    8010553a <alltraps>

801062b7 <vector216>:
.globl vector216
vector216:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $216
801062b9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801062be:	e9 77 f2 ff ff       	jmp    8010553a <alltraps>

801062c3 <vector217>:
.globl vector217
vector217:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $217
801062c5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801062ca:	e9 6b f2 ff ff       	jmp    8010553a <alltraps>

801062cf <vector218>:
.globl vector218
vector218:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $218
801062d1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801062d6:	e9 5f f2 ff ff       	jmp    8010553a <alltraps>

801062db <vector219>:
.globl vector219
vector219:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $219
801062dd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801062e2:	e9 53 f2 ff ff       	jmp    8010553a <alltraps>

801062e7 <vector220>:
.globl vector220
vector220:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $220
801062e9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801062ee:	e9 47 f2 ff ff       	jmp    8010553a <alltraps>

801062f3 <vector221>:
.globl vector221
vector221:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $221
801062f5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801062fa:	e9 3b f2 ff ff       	jmp    8010553a <alltraps>

801062ff <vector222>:
.globl vector222
vector222:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $222
80106301:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106306:	e9 2f f2 ff ff       	jmp    8010553a <alltraps>

8010630b <vector223>:
.globl vector223
vector223:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $223
8010630d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106312:	e9 23 f2 ff ff       	jmp    8010553a <alltraps>

80106317 <vector224>:
.globl vector224
vector224:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $224
80106319:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010631e:	e9 17 f2 ff ff       	jmp    8010553a <alltraps>

80106323 <vector225>:
.globl vector225
vector225:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $225
80106325:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010632a:	e9 0b f2 ff ff       	jmp    8010553a <alltraps>

8010632f <vector226>:
.globl vector226
vector226:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $226
80106331:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106336:	e9 ff f1 ff ff       	jmp    8010553a <alltraps>

8010633b <vector227>:
.globl vector227
vector227:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $227
8010633d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106342:	e9 f3 f1 ff ff       	jmp    8010553a <alltraps>

80106347 <vector228>:
.globl vector228
vector228:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $228
80106349:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010634e:	e9 e7 f1 ff ff       	jmp    8010553a <alltraps>

80106353 <vector229>:
.globl vector229
vector229:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $229
80106355:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010635a:	e9 db f1 ff ff       	jmp    8010553a <alltraps>

8010635f <vector230>:
.globl vector230
vector230:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $230
80106361:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106366:	e9 cf f1 ff ff       	jmp    8010553a <alltraps>

8010636b <vector231>:
.globl vector231
vector231:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $231
8010636d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106372:	e9 c3 f1 ff ff       	jmp    8010553a <alltraps>

80106377 <vector232>:
.globl vector232
vector232:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $232
80106379:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010637e:	e9 b7 f1 ff ff       	jmp    8010553a <alltraps>

80106383 <vector233>:
.globl vector233
vector233:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $233
80106385:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010638a:	e9 ab f1 ff ff       	jmp    8010553a <alltraps>

8010638f <vector234>:
.globl vector234
vector234:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $234
80106391:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106396:	e9 9f f1 ff ff       	jmp    8010553a <alltraps>

8010639b <vector235>:
.globl vector235
vector235:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $235
8010639d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801063a2:	e9 93 f1 ff ff       	jmp    8010553a <alltraps>

801063a7 <vector236>:
.globl vector236
vector236:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $236
801063a9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801063ae:	e9 87 f1 ff ff       	jmp    8010553a <alltraps>

801063b3 <vector237>:
.globl vector237
vector237:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $237
801063b5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801063ba:	e9 7b f1 ff ff       	jmp    8010553a <alltraps>

801063bf <vector238>:
.globl vector238
vector238:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $238
801063c1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801063c6:	e9 6f f1 ff ff       	jmp    8010553a <alltraps>

801063cb <vector239>:
.globl vector239
vector239:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $239
801063cd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801063d2:	e9 63 f1 ff ff       	jmp    8010553a <alltraps>

801063d7 <vector240>:
.globl vector240
vector240:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $240
801063d9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801063de:	e9 57 f1 ff ff       	jmp    8010553a <alltraps>

801063e3 <vector241>:
.globl vector241
vector241:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $241
801063e5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801063ea:	e9 4b f1 ff ff       	jmp    8010553a <alltraps>

801063ef <vector242>:
.globl vector242
vector242:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $242
801063f1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801063f6:	e9 3f f1 ff ff       	jmp    8010553a <alltraps>

801063fb <vector243>:
.globl vector243
vector243:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $243
801063fd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106402:	e9 33 f1 ff ff       	jmp    8010553a <alltraps>

80106407 <vector244>:
.globl vector244
vector244:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $244
80106409:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010640e:	e9 27 f1 ff ff       	jmp    8010553a <alltraps>

80106413 <vector245>:
.globl vector245
vector245:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $245
80106415:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010641a:	e9 1b f1 ff ff       	jmp    8010553a <alltraps>

8010641f <vector246>:
.globl vector246
vector246:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $246
80106421:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106426:	e9 0f f1 ff ff       	jmp    8010553a <alltraps>

8010642b <vector247>:
.globl vector247
vector247:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $247
8010642d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106432:	e9 03 f1 ff ff       	jmp    8010553a <alltraps>

80106437 <vector248>:
.globl vector248
vector248:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $248
80106439:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010643e:	e9 f7 f0 ff ff       	jmp    8010553a <alltraps>

80106443 <vector249>:
.globl vector249
vector249:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $249
80106445:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010644a:	e9 eb f0 ff ff       	jmp    8010553a <alltraps>

8010644f <vector250>:
.globl vector250
vector250:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $250
80106451:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106456:	e9 df f0 ff ff       	jmp    8010553a <alltraps>

8010645b <vector251>:
.globl vector251
vector251:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $251
8010645d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106462:	e9 d3 f0 ff ff       	jmp    8010553a <alltraps>

80106467 <vector252>:
.globl vector252
vector252:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $252
80106469:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010646e:	e9 c7 f0 ff ff       	jmp    8010553a <alltraps>

80106473 <vector253>:
.globl vector253
vector253:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $253
80106475:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010647a:	e9 bb f0 ff ff       	jmp    8010553a <alltraps>

8010647f <vector254>:
.globl vector254
vector254:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $254
80106481:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106486:	e9 af f0 ff ff       	jmp    8010553a <alltraps>

8010648b <vector255>:
.globl vector255
vector255:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $255
8010648d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106492:	e9 a3 f0 ff ff       	jmp    8010553a <alltraps>
80106497:	66 90                	xchg   %ax,%ax
80106499:	66 90                	xchg   %ax,%ax
8010649b:	66 90                	xchg   %ax,%ax
8010649d:	66 90                	xchg   %ax,%ax
8010649f:	90                   	nop

801064a0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801064a0:	55                   	push   %ebp
801064a1:	89 e5                	mov    %esp,%ebp
801064a3:	57                   	push   %edi
801064a4:	56                   	push   %esi
801064a5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801064a6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801064ac:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801064b2:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
801064b5:	39 d3                	cmp    %edx,%ebx
801064b7:	73 56                	jae    8010650f <deallocuvm.part.0+0x6f>
801064b9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801064bc:	89 c6                	mov    %eax,%esi
801064be:	89 d7                	mov    %edx,%edi
801064c0:	eb 12                	jmp    801064d4 <deallocuvm.part.0+0x34>
801064c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801064c8:	83 c2 01             	add    $0x1,%edx
801064cb:	89 d3                	mov    %edx,%ebx
801064cd:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
801064d0:	39 fb                	cmp    %edi,%ebx
801064d2:	73 38                	jae    8010650c <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
801064d4:	89 da                	mov    %ebx,%edx
801064d6:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801064d9:	8b 04 96             	mov    (%esi,%edx,4),%eax
801064dc:	a8 01                	test   $0x1,%al
801064de:	74 e8                	je     801064c8 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
801064e0:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801064e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801064e7:	c1 e9 0a             	shr    $0xa,%ecx
801064ea:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
801064f0:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
801064f7:	85 c0                	test   %eax,%eax
801064f9:	74 cd                	je     801064c8 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
801064fb:	8b 10                	mov    (%eax),%edx
801064fd:	f6 c2 01             	test   $0x1,%dl
80106500:	75 1e                	jne    80106520 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80106502:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106508:	39 fb                	cmp    %edi,%ebx
8010650a:	72 c8                	jb     801064d4 <deallocuvm.part.0+0x34>
8010650c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
8010650f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106512:	89 c8                	mov    %ecx,%eax
80106514:	5b                   	pop    %ebx
80106515:	5e                   	pop    %esi
80106516:	5f                   	pop    %edi
80106517:	5d                   	pop    %ebp
80106518:	c3                   	ret
80106519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106520:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106526:	74 26                	je     8010654e <deallocuvm.part.0+0xae>
      kfree(v);
80106528:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010652b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106531:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106534:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
8010653a:	52                   	push   %edx
8010653b:	e8 60 bc ff ff       	call   801021a0 <kfree>
      *pte = 0;
80106540:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80106543:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106546:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010654c:	eb 82                	jmp    801064d0 <deallocuvm.part.0+0x30>
        panic("kfree");
8010654e:	83 ec 0c             	sub    $0xc,%esp
80106551:	68 c4 70 10 80       	push   $0x801070c4
80106556:	e8 25 9e ff ff       	call   80100380 <panic>
8010655b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106560 <mappages>:
{
80106560:	55                   	push   %ebp
80106561:	89 e5                	mov    %esp,%ebp
80106563:	57                   	push   %edi
80106564:	56                   	push   %esi
80106565:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106566:	89 d3                	mov    %edx,%ebx
80106568:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010656e:	83 ec 1c             	sub    $0x1c,%esp
80106571:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106574:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106578:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010657d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106580:	8b 45 08             	mov    0x8(%ebp),%eax
80106583:	29 d8                	sub    %ebx,%eax
80106585:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106588:	eb 3f                	jmp    801065c9 <mappages+0x69>
8010658a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106590:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106592:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106597:	c1 ea 0a             	shr    $0xa,%edx
8010659a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801065a0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801065a7:	85 c0                	test   %eax,%eax
801065a9:	74 75                	je     80106620 <mappages+0xc0>
    if(*pte & PTE_P)
801065ab:	f6 00 01             	testb  $0x1,(%eax)
801065ae:	0f 85 86 00 00 00    	jne    8010663a <mappages+0xda>
    *pte = pa | perm | PTE_P;
801065b4:	0b 75 0c             	or     0xc(%ebp),%esi
801065b7:	83 ce 01             	or     $0x1,%esi
801065ba:	89 30                	mov    %esi,(%eax)
    if(a == last)
801065bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801065bf:	39 c3                	cmp    %eax,%ebx
801065c1:	74 6d                	je     80106630 <mappages+0xd0>
    a += PGSIZE;
801065c3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
801065c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
801065cc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801065cf:	8d 34 03             	lea    (%ebx,%eax,1),%esi
801065d2:	89 d8                	mov    %ebx,%eax
801065d4:	c1 e8 16             	shr    $0x16,%eax
801065d7:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
801065da:	8b 07                	mov    (%edi),%eax
801065dc:	a8 01                	test   $0x1,%al
801065de:	75 b0                	jne    80106590 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801065e0:	e8 7b bd ff ff       	call   80102360 <kalloc>
801065e5:	85 c0                	test   %eax,%eax
801065e7:	74 37                	je     80106620 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
801065e9:	83 ec 04             	sub    $0x4,%esp
801065ec:	68 00 10 00 00       	push   $0x1000
801065f1:	6a 00                	push   $0x0
801065f3:	50                   	push   %eax
801065f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
801065f7:	e8 a4 dd ff ff       	call   801043a0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801065fc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
801065ff:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106602:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106608:	83 c8 07             	or     $0x7,%eax
8010660b:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010660d:	89 d8                	mov    %ebx,%eax
8010660f:	c1 e8 0a             	shr    $0xa,%eax
80106612:	25 fc 0f 00 00       	and    $0xffc,%eax
80106617:	01 d0                	add    %edx,%eax
80106619:	eb 90                	jmp    801065ab <mappages+0x4b>
8010661b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80106620:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106623:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106628:	5b                   	pop    %ebx
80106629:	5e                   	pop    %esi
8010662a:	5f                   	pop    %edi
8010662b:	5d                   	pop    %ebp
8010662c:	c3                   	ret
8010662d:	8d 76 00             	lea    0x0(%esi),%esi
80106630:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106633:	31 c0                	xor    %eax,%eax
}
80106635:	5b                   	pop    %ebx
80106636:	5e                   	pop    %esi
80106637:	5f                   	pop    %edi
80106638:	5d                   	pop    %ebp
80106639:	c3                   	ret
      panic("remap");
8010663a:	83 ec 0c             	sub    $0xc,%esp
8010663d:	68 f8 72 10 80       	push   $0x801072f8
80106642:	e8 39 9d ff ff       	call   80100380 <panic>
80106647:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010664e:	00 
8010664f:	90                   	nop

80106650 <seginit>:
{
80106650:	55                   	push   %ebp
80106651:	89 e5                	mov    %esp,%ebp
80106653:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106656:	e8 e5 cf ff ff       	call   80103640 <cpuid>
  pd[0] = size-1;
8010665b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106660:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106666:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
8010666a:	c7 80 b8 e7 18 80 ff 	movl   $0xffff,-0x7fe71848(%eax)
80106671:	ff 00 00 
80106674:	c7 80 bc e7 18 80 00 	movl   $0xcf9a00,-0x7fe71844(%eax)
8010667b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010667e:	c7 80 c0 e7 18 80 ff 	movl   $0xffff,-0x7fe71840(%eax)
80106685:	ff 00 00 
80106688:	c7 80 c4 e7 18 80 00 	movl   $0xcf9200,-0x7fe7183c(%eax)
8010668f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106692:	c7 80 c8 e7 18 80 ff 	movl   $0xffff,-0x7fe71838(%eax)
80106699:	ff 00 00 
8010669c:	c7 80 cc e7 18 80 00 	movl   $0xcffa00,-0x7fe71834(%eax)
801066a3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801066a6:	c7 80 d0 e7 18 80 ff 	movl   $0xffff,-0x7fe71830(%eax)
801066ad:	ff 00 00 
801066b0:	c7 80 d4 e7 18 80 00 	movl   $0xcff200,-0x7fe7182c(%eax)
801066b7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801066ba:	05 b0 e7 18 80       	add    $0x8018e7b0,%eax
  pd[1] = (uint)p;
801066bf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801066c3:	c1 e8 10             	shr    $0x10,%eax
801066c6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801066ca:	8d 45 f2             	lea    -0xe(%ebp),%eax
801066cd:	0f 01 10             	lgdtl  (%eax)
}
801066d0:	c9                   	leave
801066d1:	c3                   	ret
801066d2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801066d9:	00 
801066da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801066e0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801066e0:	a1 64 14 19 80       	mov    0x80191464,%eax
801066e5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801066ea:	0f 22 d8             	mov    %eax,%cr3
}
801066ed:	c3                   	ret
801066ee:	66 90                	xchg   %ax,%ax

801066f0 <switchuvm>:
{
801066f0:	55                   	push   %ebp
801066f1:	89 e5                	mov    %esp,%ebp
801066f3:	57                   	push   %edi
801066f4:	56                   	push   %esi
801066f5:	53                   	push   %ebx
801066f6:	83 ec 1c             	sub    $0x1c,%esp
801066f9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801066fc:	85 f6                	test   %esi,%esi
801066fe:	0f 84 cb 00 00 00    	je     801067cf <switchuvm+0xdf>
  if(p->kstack == 0)
80106704:	8b 46 08             	mov    0x8(%esi),%eax
80106707:	85 c0                	test   %eax,%eax
80106709:	0f 84 da 00 00 00    	je     801067e9 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010670f:	8b 46 04             	mov    0x4(%esi),%eax
80106712:	85 c0                	test   %eax,%eax
80106714:	0f 84 c2 00 00 00    	je     801067dc <switchuvm+0xec>
  pushcli();
8010671a:	e8 31 da ff ff       	call   80104150 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010671f:	e8 bc ce ff ff       	call   801035e0 <mycpu>
80106724:	89 c3                	mov    %eax,%ebx
80106726:	e8 b5 ce ff ff       	call   801035e0 <mycpu>
8010672b:	89 c7                	mov    %eax,%edi
8010672d:	e8 ae ce ff ff       	call   801035e0 <mycpu>
80106732:	83 c7 08             	add    $0x8,%edi
80106735:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106738:	e8 a3 ce ff ff       	call   801035e0 <mycpu>
8010673d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106740:	ba 67 00 00 00       	mov    $0x67,%edx
80106745:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010674c:	83 c0 08             	add    $0x8,%eax
8010674f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106756:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010675b:	83 c1 08             	add    $0x8,%ecx
8010675e:	c1 e8 18             	shr    $0x18,%eax
80106761:	c1 e9 10             	shr    $0x10,%ecx
80106764:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010676a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106770:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106775:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010677c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106781:	e8 5a ce ff ff       	call   801035e0 <mycpu>
80106786:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010678d:	e8 4e ce ff ff       	call   801035e0 <mycpu>
80106792:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106796:	8b 5e 08             	mov    0x8(%esi),%ebx
80106799:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010679f:	e8 3c ce ff ff       	call   801035e0 <mycpu>
801067a4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801067a7:	e8 34 ce ff ff       	call   801035e0 <mycpu>
801067ac:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801067b0:	b8 28 00 00 00       	mov    $0x28,%eax
801067b5:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801067b8:	8b 46 04             	mov    0x4(%esi),%eax
801067bb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801067c0:	0f 22 d8             	mov    %eax,%cr3
}
801067c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067c6:	5b                   	pop    %ebx
801067c7:	5e                   	pop    %esi
801067c8:	5f                   	pop    %edi
801067c9:	5d                   	pop    %ebp
  popcli();
801067ca:	e9 d1 d9 ff ff       	jmp    801041a0 <popcli>
    panic("switchuvm: no process");
801067cf:	83 ec 0c             	sub    $0xc,%esp
801067d2:	68 fe 72 10 80       	push   $0x801072fe
801067d7:	e8 a4 9b ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
801067dc:	83 ec 0c             	sub    $0xc,%esp
801067df:	68 29 73 10 80       	push   $0x80107329
801067e4:	e8 97 9b ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
801067e9:	83 ec 0c             	sub    $0xc,%esp
801067ec:	68 14 73 10 80       	push   $0x80107314
801067f1:	e8 8a 9b ff ff       	call   80100380 <panic>
801067f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801067fd:	00 
801067fe:	66 90                	xchg   %ax,%ax

80106800 <inituvm>:
{
80106800:	55                   	push   %ebp
80106801:	89 e5                	mov    %esp,%ebp
80106803:	57                   	push   %edi
80106804:	56                   	push   %esi
80106805:	53                   	push   %ebx
80106806:	83 ec 1c             	sub    $0x1c,%esp
80106809:	8b 45 08             	mov    0x8(%ebp),%eax
8010680c:	8b 75 10             	mov    0x10(%ebp),%esi
8010680f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106812:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106815:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010681b:	77 49                	ja     80106866 <inituvm+0x66>
  mem = kalloc();
8010681d:	e8 3e bb ff ff       	call   80102360 <kalloc>
  memset(mem, 0, PGSIZE);
80106822:	83 ec 04             	sub    $0x4,%esp
80106825:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010682a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010682c:	6a 00                	push   $0x0
8010682e:	50                   	push   %eax
8010682f:	e8 6c db ff ff       	call   801043a0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106834:	58                   	pop    %eax
80106835:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010683b:	5a                   	pop    %edx
8010683c:	6a 06                	push   $0x6
8010683e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106843:	31 d2                	xor    %edx,%edx
80106845:	50                   	push   %eax
80106846:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106849:	e8 12 fd ff ff       	call   80106560 <mappages>
  memmove(mem, init, sz);
8010684e:	83 c4 10             	add    $0x10,%esp
80106851:	89 75 10             	mov    %esi,0x10(%ebp)
80106854:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106857:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010685a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010685d:	5b                   	pop    %ebx
8010685e:	5e                   	pop    %esi
8010685f:	5f                   	pop    %edi
80106860:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106861:	e9 ca db ff ff       	jmp    80104430 <memmove>
    panic("inituvm: more than a page");
80106866:	83 ec 0c             	sub    $0xc,%esp
80106869:	68 3d 73 10 80       	push   $0x8010733d
8010686e:	e8 0d 9b ff ff       	call   80100380 <panic>
80106873:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010687a:	00 
8010687b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106880 <loaduvm>:
{
80106880:	55                   	push   %ebp
80106881:	89 e5                	mov    %esp,%ebp
80106883:	57                   	push   %edi
80106884:	56                   	push   %esi
80106885:	53                   	push   %ebx
80106886:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106889:	8b 75 0c             	mov    0xc(%ebp),%esi
{
8010688c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
8010688f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106895:	0f 85 a2 00 00 00    	jne    8010693d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
8010689b:	85 ff                	test   %edi,%edi
8010689d:	74 7d                	je     8010691c <loaduvm+0x9c>
8010689f:	90                   	nop
  pde = &pgdir[PDX(va)];
801068a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801068a3:	8b 55 08             	mov    0x8(%ebp),%edx
801068a6:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
801068a8:	89 c1                	mov    %eax,%ecx
801068aa:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801068ad:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
801068b0:	f6 c1 01             	test   $0x1,%cl
801068b3:	75 13                	jne    801068c8 <loaduvm+0x48>
      panic("loaduvm: address should exist");
801068b5:	83 ec 0c             	sub    $0xc,%esp
801068b8:	68 57 73 10 80       	push   $0x80107357
801068bd:	e8 be 9a ff ff       	call   80100380 <panic>
801068c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801068c8:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801068cb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801068d1:	25 fc 0f 00 00       	and    $0xffc,%eax
801068d6:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801068dd:	85 c9                	test   %ecx,%ecx
801068df:	74 d4                	je     801068b5 <loaduvm+0x35>
    if(sz - i < PGSIZE)
801068e1:	89 fb                	mov    %edi,%ebx
801068e3:	b8 00 10 00 00       	mov    $0x1000,%eax
801068e8:	29 f3                	sub    %esi,%ebx
801068ea:	39 c3                	cmp    %eax,%ebx
801068ec:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
801068ef:	53                   	push   %ebx
801068f0:	8b 45 14             	mov    0x14(%ebp),%eax
801068f3:	01 f0                	add    %esi,%eax
801068f5:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
801068f6:	8b 01                	mov    (%ecx),%eax
801068f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801068fd:	05 00 00 00 80       	add    $0x80000000,%eax
80106902:	50                   	push   %eax
80106903:	ff 75 10             	push   0x10(%ebp)
80106906:	e8 a5 b1 ff ff       	call   80101ab0 <readi>
8010690b:	83 c4 10             	add    $0x10,%esp
8010690e:	39 d8                	cmp    %ebx,%eax
80106910:	75 1e                	jne    80106930 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80106912:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106918:	39 fe                	cmp    %edi,%esi
8010691a:	72 84                	jb     801068a0 <loaduvm+0x20>
}
8010691c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010691f:	31 c0                	xor    %eax,%eax
}
80106921:	5b                   	pop    %ebx
80106922:	5e                   	pop    %esi
80106923:	5f                   	pop    %edi
80106924:	5d                   	pop    %ebp
80106925:	c3                   	ret
80106926:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010692d:	00 
8010692e:	66 90                	xchg   %ax,%ax
80106930:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106933:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106938:	5b                   	pop    %ebx
80106939:	5e                   	pop    %esi
8010693a:	5f                   	pop    %edi
8010693b:	5d                   	pop    %ebp
8010693c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
8010693d:	83 ec 0c             	sub    $0xc,%esp
80106940:	68 dc 75 10 80       	push   $0x801075dc
80106945:	e8 36 9a ff ff       	call   80100380 <panic>
8010694a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106950 <allocuvm>:
{
80106950:	55                   	push   %ebp
80106951:	89 e5                	mov    %esp,%ebp
80106953:	57                   	push   %edi
80106954:	56                   	push   %esi
80106955:	53                   	push   %ebx
80106956:	83 ec 1c             	sub    $0x1c,%esp
80106959:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
8010695c:	85 f6                	test   %esi,%esi
8010695e:	0f 88 98 00 00 00    	js     801069fc <allocuvm+0xac>
80106964:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80106966:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106969:	0f 82 a1 00 00 00    	jb     80106a10 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010696f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106972:	05 ff 0f 00 00       	add    $0xfff,%eax
80106977:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010697c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
8010697e:	39 f0                	cmp    %esi,%eax
80106980:	0f 83 8d 00 00 00    	jae    80106a13 <allocuvm+0xc3>
80106986:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80106989:	eb 44                	jmp    801069cf <allocuvm+0x7f>
8010698b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106990:	83 ec 04             	sub    $0x4,%esp
80106993:	68 00 10 00 00       	push   $0x1000
80106998:	6a 00                	push   $0x0
8010699a:	50                   	push   %eax
8010699b:	e8 00 da ff ff       	call   801043a0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801069a0:	58                   	pop    %eax
801069a1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801069a7:	5a                   	pop    %edx
801069a8:	6a 06                	push   $0x6
801069aa:	b9 00 10 00 00       	mov    $0x1000,%ecx
801069af:	89 fa                	mov    %edi,%edx
801069b1:	50                   	push   %eax
801069b2:	8b 45 08             	mov    0x8(%ebp),%eax
801069b5:	e8 a6 fb ff ff       	call   80106560 <mappages>
801069ba:	83 c4 10             	add    $0x10,%esp
801069bd:	85 c0                	test   %eax,%eax
801069bf:	78 5f                	js     80106a20 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
801069c1:	81 c7 00 10 00 00    	add    $0x1000,%edi
801069c7:	39 f7                	cmp    %esi,%edi
801069c9:	0f 83 89 00 00 00    	jae    80106a58 <allocuvm+0x108>
    mem = kalloc();
801069cf:	e8 8c b9 ff ff       	call   80102360 <kalloc>
801069d4:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801069d6:	85 c0                	test   %eax,%eax
801069d8:	75 b6                	jne    80106990 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801069da:	83 ec 0c             	sub    $0xc,%esp
801069dd:	68 75 73 10 80       	push   $0x80107375
801069e2:	e8 c9 9c ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801069e7:	83 c4 10             	add    $0x10,%esp
801069ea:	3b 75 0c             	cmp    0xc(%ebp),%esi
801069ed:	74 0d                	je     801069fc <allocuvm+0xac>
801069ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801069f2:	8b 45 08             	mov    0x8(%ebp),%eax
801069f5:	89 f2                	mov    %esi,%edx
801069f7:	e8 a4 fa ff ff       	call   801064a0 <deallocuvm.part.0>
    return 0;
801069fc:	31 d2                	xor    %edx,%edx
}
801069fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a01:	89 d0                	mov    %edx,%eax
80106a03:	5b                   	pop    %ebx
80106a04:	5e                   	pop    %esi
80106a05:	5f                   	pop    %edi
80106a06:	5d                   	pop    %ebp
80106a07:	c3                   	ret
80106a08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106a0f:	00 
    return oldsz;
80106a10:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80106a13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a16:	89 d0                	mov    %edx,%eax
80106a18:	5b                   	pop    %ebx
80106a19:	5e                   	pop    %esi
80106a1a:	5f                   	pop    %edi
80106a1b:	5d                   	pop    %ebp
80106a1c:	c3                   	ret
80106a1d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106a20:	83 ec 0c             	sub    $0xc,%esp
80106a23:	68 8d 73 10 80       	push   $0x8010738d
80106a28:	e8 83 9c ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106a2d:	83 c4 10             	add    $0x10,%esp
80106a30:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106a33:	74 0d                	je     80106a42 <allocuvm+0xf2>
80106a35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106a38:	8b 45 08             	mov    0x8(%ebp),%eax
80106a3b:	89 f2                	mov    %esi,%edx
80106a3d:	e8 5e fa ff ff       	call   801064a0 <deallocuvm.part.0>
      kfree(mem);
80106a42:	83 ec 0c             	sub    $0xc,%esp
80106a45:	53                   	push   %ebx
80106a46:	e8 55 b7 ff ff       	call   801021a0 <kfree>
      return 0;
80106a4b:	83 c4 10             	add    $0x10,%esp
    return 0;
80106a4e:	31 d2                	xor    %edx,%edx
80106a50:	eb ac                	jmp    801069fe <allocuvm+0xae>
80106a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
80106a5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a5e:	5b                   	pop    %ebx
80106a5f:	5e                   	pop    %esi
80106a60:	89 d0                	mov    %edx,%eax
80106a62:	5f                   	pop    %edi
80106a63:	5d                   	pop    %ebp
80106a64:	c3                   	ret
80106a65:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106a6c:	00 
80106a6d:	8d 76 00             	lea    0x0(%esi),%esi

80106a70 <deallocuvm>:
{
80106a70:	55                   	push   %ebp
80106a71:	89 e5                	mov    %esp,%ebp
80106a73:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a76:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106a79:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106a7c:	39 d1                	cmp    %edx,%ecx
80106a7e:	73 10                	jae    80106a90 <deallocuvm+0x20>
}
80106a80:	5d                   	pop    %ebp
80106a81:	e9 1a fa ff ff       	jmp    801064a0 <deallocuvm.part.0>
80106a86:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106a8d:	00 
80106a8e:	66 90                	xchg   %ax,%ax
80106a90:	89 d0                	mov    %edx,%eax
80106a92:	5d                   	pop    %ebp
80106a93:	c3                   	ret
80106a94:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106a9b:	00 
80106a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106aa0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106aa0:	55                   	push   %ebp
80106aa1:	89 e5                	mov    %esp,%ebp
80106aa3:	57                   	push   %edi
80106aa4:	56                   	push   %esi
80106aa5:	53                   	push   %ebx
80106aa6:	83 ec 0c             	sub    $0xc,%esp
80106aa9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106aac:	85 f6                	test   %esi,%esi
80106aae:	74 59                	je     80106b09 <freevm+0x69>
  if(newsz >= oldsz)
80106ab0:	31 c9                	xor    %ecx,%ecx
80106ab2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106ab7:	89 f0                	mov    %esi,%eax
80106ab9:	89 f3                	mov    %esi,%ebx
80106abb:	e8 e0 f9 ff ff       	call   801064a0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ac0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106ac6:	eb 0f                	jmp    80106ad7 <freevm+0x37>
80106ac8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106acf:	00 
80106ad0:	83 c3 04             	add    $0x4,%ebx
80106ad3:	39 fb                	cmp    %edi,%ebx
80106ad5:	74 23                	je     80106afa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106ad7:	8b 03                	mov    (%ebx),%eax
80106ad9:	a8 01                	test   $0x1,%al
80106adb:	74 f3                	je     80106ad0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106add:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106ae2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106ae5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106ae8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106aed:	50                   	push   %eax
80106aee:	e8 ad b6 ff ff       	call   801021a0 <kfree>
80106af3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106af6:	39 fb                	cmp    %edi,%ebx
80106af8:	75 dd                	jne    80106ad7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106afa:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106afd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b00:	5b                   	pop    %ebx
80106b01:	5e                   	pop    %esi
80106b02:	5f                   	pop    %edi
80106b03:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106b04:	e9 97 b6 ff ff       	jmp    801021a0 <kfree>
    panic("freevm: no pgdir");
80106b09:	83 ec 0c             	sub    $0xc,%esp
80106b0c:	68 a9 73 10 80       	push   $0x801073a9
80106b11:	e8 6a 98 ff ff       	call   80100380 <panic>
80106b16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106b1d:	00 
80106b1e:	66 90                	xchg   %ax,%ax

80106b20 <setupkvm>:
{
80106b20:	55                   	push   %ebp
80106b21:	89 e5                	mov    %esp,%ebp
80106b23:	56                   	push   %esi
80106b24:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106b25:	e8 36 b8 ff ff       	call   80102360 <kalloc>
80106b2a:	85 c0                	test   %eax,%eax
80106b2c:	74 5e                	je     80106b8c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
80106b2e:	83 ec 04             	sub    $0x4,%esp
80106b31:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106b33:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106b38:	68 00 10 00 00       	push   $0x1000
80106b3d:	6a 00                	push   $0x0
80106b3f:	50                   	push   %eax
80106b40:	e8 5b d8 ff ff       	call   801043a0 <memset>
80106b45:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106b48:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106b4b:	83 ec 08             	sub    $0x8,%esp
80106b4e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106b51:	8b 13                	mov    (%ebx),%edx
80106b53:	ff 73 0c             	push   0xc(%ebx)
80106b56:	50                   	push   %eax
80106b57:	29 c1                	sub    %eax,%ecx
80106b59:	89 f0                	mov    %esi,%eax
80106b5b:	e8 00 fa ff ff       	call   80106560 <mappages>
80106b60:	83 c4 10             	add    $0x10,%esp
80106b63:	85 c0                	test   %eax,%eax
80106b65:	78 19                	js     80106b80 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106b67:	83 c3 10             	add    $0x10,%ebx
80106b6a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106b70:	75 d6                	jne    80106b48 <setupkvm+0x28>
}
80106b72:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106b75:	89 f0                	mov    %esi,%eax
80106b77:	5b                   	pop    %ebx
80106b78:	5e                   	pop    %esi
80106b79:	5d                   	pop    %ebp
80106b7a:	c3                   	ret
80106b7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80106b80:	83 ec 0c             	sub    $0xc,%esp
80106b83:	56                   	push   %esi
80106b84:	e8 17 ff ff ff       	call   80106aa0 <freevm>
      return 0;
80106b89:	83 c4 10             	add    $0x10,%esp
}
80106b8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
80106b8f:	31 f6                	xor    %esi,%esi
}
80106b91:	89 f0                	mov    %esi,%eax
80106b93:	5b                   	pop    %ebx
80106b94:	5e                   	pop    %esi
80106b95:	5d                   	pop    %ebp
80106b96:	c3                   	ret
80106b97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106b9e:	00 
80106b9f:	90                   	nop

80106ba0 <kvmalloc>:
{
80106ba0:	55                   	push   %ebp
80106ba1:	89 e5                	mov    %esp,%ebp
80106ba3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106ba6:	e8 75 ff ff ff       	call   80106b20 <setupkvm>
80106bab:	a3 64 14 19 80       	mov    %eax,0x80191464
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106bb0:	05 00 00 00 80       	add    $0x80000000,%eax
80106bb5:	0f 22 d8             	mov    %eax,%cr3
}
80106bb8:	c9                   	leave
80106bb9:	c3                   	ret
80106bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106bc0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106bc0:	55                   	push   %ebp
80106bc1:	89 e5                	mov    %esp,%ebp
80106bc3:	83 ec 08             	sub    $0x8,%esp
80106bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106bc9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80106bcc:	89 c1                	mov    %eax,%ecx
80106bce:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106bd1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80106bd4:	f6 c2 01             	test   $0x1,%dl
80106bd7:	75 17                	jne    80106bf0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106bd9:	83 ec 0c             	sub    $0xc,%esp
80106bdc:	68 ba 73 10 80       	push   $0x801073ba
80106be1:	e8 9a 97 ff ff       	call   80100380 <panic>
80106be6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106bed:	00 
80106bee:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
80106bf0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106bf3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106bf9:	25 fc 0f 00 00       	and    $0xffc,%eax
80106bfe:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80106c05:	85 c0                	test   %eax,%eax
80106c07:	74 d0                	je     80106bd9 <clearpteu+0x19>
  *pte &= ~PTE_U;
80106c09:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106c0c:	c9                   	leave
80106c0d:	c3                   	ret
80106c0e:	66 90                	xchg   %ax,%ax

80106c10 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106c10:	55                   	push   %ebp
80106c11:	89 e5                	mov    %esp,%ebp
80106c13:	57                   	push   %edi
80106c14:	56                   	push   %esi
80106c15:	53                   	push   %ebx
80106c16:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106c19:	e8 02 ff ff ff       	call   80106b20 <setupkvm>
80106c1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106c21:	85 c0                	test   %eax,%eax
80106c23:	0f 84 e9 00 00 00    	je     80106d12 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106c29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106c2c:	85 c9                	test   %ecx,%ecx
80106c2e:	0f 84 b2 00 00 00    	je     80106ce6 <copyuvm+0xd6>
80106c34:	31 f6                	xor    %esi,%esi
80106c36:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106c3d:	00 
80106c3e:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
80106c40:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80106c43:	89 f0                	mov    %esi,%eax
80106c45:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106c48:	8b 04 81             	mov    (%ecx,%eax,4),%eax
80106c4b:	a8 01                	test   $0x1,%al
80106c4d:	75 11                	jne    80106c60 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106c4f:	83 ec 0c             	sub    $0xc,%esp
80106c52:	68 c4 73 10 80       	push   $0x801073c4
80106c57:	e8 24 97 ff ff       	call   80100380 <panic>
80106c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80106c60:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c62:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106c67:	c1 ea 0a             	shr    $0xa,%edx
80106c6a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106c70:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106c77:	85 c0                	test   %eax,%eax
80106c79:	74 d4                	je     80106c4f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
80106c7b:	8b 00                	mov    (%eax),%eax
80106c7d:	a8 01                	test   $0x1,%al
80106c7f:	0f 84 9f 00 00 00    	je     80106d24 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106c85:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80106c87:	25 ff 0f 00 00       	and    $0xfff,%eax
80106c8c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106c8f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80106c95:	e8 c6 b6 ff ff       	call   80102360 <kalloc>
80106c9a:	89 c3                	mov    %eax,%ebx
80106c9c:	85 c0                	test   %eax,%eax
80106c9e:	74 64                	je     80106d04 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106ca0:	83 ec 04             	sub    $0x4,%esp
80106ca3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106ca9:	68 00 10 00 00       	push   $0x1000
80106cae:	57                   	push   %edi
80106caf:	50                   	push   %eax
80106cb0:	e8 7b d7 ff ff       	call   80104430 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106cb5:	58                   	pop    %eax
80106cb6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106cbc:	5a                   	pop    %edx
80106cbd:	ff 75 e4             	push   -0x1c(%ebp)
80106cc0:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106cc5:	89 f2                	mov    %esi,%edx
80106cc7:	50                   	push   %eax
80106cc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ccb:	e8 90 f8 ff ff       	call   80106560 <mappages>
80106cd0:	83 c4 10             	add    $0x10,%esp
80106cd3:	85 c0                	test   %eax,%eax
80106cd5:	78 21                	js     80106cf8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80106cd7:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106cdd:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106ce0:	0f 82 5a ff ff ff    	jb     80106c40 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80106ce6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ce9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cec:	5b                   	pop    %ebx
80106ced:	5e                   	pop    %esi
80106cee:	5f                   	pop    %edi
80106cef:	5d                   	pop    %ebp
80106cf0:	c3                   	ret
80106cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80106cf8:	83 ec 0c             	sub    $0xc,%esp
80106cfb:	53                   	push   %ebx
80106cfc:	e8 9f b4 ff ff       	call   801021a0 <kfree>
      goto bad;
80106d01:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80106d04:	83 ec 0c             	sub    $0xc,%esp
80106d07:	ff 75 e0             	push   -0x20(%ebp)
80106d0a:	e8 91 fd ff ff       	call   80106aa0 <freevm>
  return 0;
80106d0f:	83 c4 10             	add    $0x10,%esp
    return 0;
80106d12:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80106d19:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d1f:	5b                   	pop    %ebx
80106d20:	5e                   	pop    %esi
80106d21:	5f                   	pop    %edi
80106d22:	5d                   	pop    %ebp
80106d23:	c3                   	ret
      panic("copyuvm: page not present");
80106d24:	83 ec 0c             	sub    $0xc,%esp
80106d27:	68 de 73 10 80       	push   $0x801073de
80106d2c:	e8 4f 96 ff ff       	call   80100380 <panic>
80106d31:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106d38:	00 
80106d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d40 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106d46:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80106d49:	89 c1                	mov    %eax,%ecx
80106d4b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106d4e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80106d51:	f6 c2 01             	test   $0x1,%dl
80106d54:	0f 84 f8 00 00 00    	je     80106e52 <uva2ka.cold>
  return &pgtab[PTX(va)];
80106d5a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d5d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80106d63:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80106d64:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80106d69:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106d70:	89 d0                	mov    %edx,%eax
80106d72:	f7 d2                	not    %edx
80106d74:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d79:	05 00 00 00 80       	add    $0x80000000,%eax
80106d7e:	83 e2 05             	and    $0x5,%edx
80106d81:	ba 00 00 00 00       	mov    $0x0,%edx
80106d86:	0f 45 c2             	cmovne %edx,%eax
}
80106d89:	c3                   	ret
80106d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d90 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106d90:	55                   	push   %ebp
80106d91:	89 e5                	mov    %esp,%ebp
80106d93:	57                   	push   %edi
80106d94:	56                   	push   %esi
80106d95:	53                   	push   %ebx
80106d96:	83 ec 0c             	sub    $0xc,%esp
80106d99:	8b 75 14             	mov    0x14(%ebp),%esi
80106d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d9f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106da2:	85 f6                	test   %esi,%esi
80106da4:	75 51                	jne    80106df7 <copyout+0x67>
80106da6:	e9 9d 00 00 00       	jmp    80106e48 <copyout+0xb8>
80106dab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
80106db0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106db6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80106dbc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80106dc2:	74 74                	je     80106e38 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
80106dc4:	89 fb                	mov    %edi,%ebx
80106dc6:	29 c3                	sub    %eax,%ebx
80106dc8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80106dce:	39 f3                	cmp    %esi,%ebx
80106dd0:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106dd3:	29 f8                	sub    %edi,%eax
80106dd5:	83 ec 04             	sub    $0x4,%esp
80106dd8:	01 c1                	add    %eax,%ecx
80106dda:	53                   	push   %ebx
80106ddb:	52                   	push   %edx
80106ddc:	89 55 10             	mov    %edx,0x10(%ebp)
80106ddf:	51                   	push   %ecx
80106de0:	e8 4b d6 ff ff       	call   80104430 <memmove>
    len -= n;
    buf += n;
80106de5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80106de8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
80106dee:	83 c4 10             	add    $0x10,%esp
    buf += n;
80106df1:	01 da                	add    %ebx,%edx
  while(len > 0){
80106df3:	29 de                	sub    %ebx,%esi
80106df5:	74 51                	je     80106e48 <copyout+0xb8>
  if(*pde & PTE_P){
80106df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80106dfa:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80106dfc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
80106dfe:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80106e01:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80106e07:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80106e0a:	f6 c1 01             	test   $0x1,%cl
80106e0d:	0f 84 46 00 00 00    	je     80106e59 <copyout.cold>
  return &pgtab[PTX(va)];
80106e13:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e15:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106e1b:	c1 eb 0c             	shr    $0xc,%ebx
80106e1e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80106e24:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80106e2b:	89 d9                	mov    %ebx,%ecx
80106e2d:	f7 d1                	not    %ecx
80106e2f:	83 e1 05             	and    $0x5,%ecx
80106e32:	0f 84 78 ff ff ff    	je     80106db0 <copyout+0x20>
  }
  return 0;
}
80106e38:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e40:	5b                   	pop    %ebx
80106e41:	5e                   	pop    %esi
80106e42:	5f                   	pop    %edi
80106e43:	5d                   	pop    %ebp
80106e44:	c3                   	ret
80106e45:	8d 76 00             	lea    0x0(%esi),%esi
80106e48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e4b:	31 c0                	xor    %eax,%eax
}
80106e4d:	5b                   	pop    %ebx
80106e4e:	5e                   	pop    %esi
80106e4f:	5f                   	pop    %edi
80106e50:	5d                   	pop    %ebp
80106e51:	c3                   	ret

80106e52 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80106e52:	a1 00 00 00 00       	mov    0x0,%eax
80106e57:	0f 0b                	ud2

80106e59 <copyout.cold>:
80106e59:	a1 00 00 00 00       	mov    0x0,%eax
80106e5e:	0f 0b                	ud2

80106e60 <ideinit>:
static uchar *memdisk;

void
ideinit(void)
{
  memdisk = _binary_fs_img_start;
80106e60:	c7 05 68 14 19 80 16 	movl   $0x8010a516,0x80191468
80106e67:	a5 10 80 
  disksize = (uint)_binary_fs_img_size/BSIZE;
80106e6a:	b8 00 d0 07 00       	mov    $0x7d000,%eax
80106e6f:	c1 e8 09             	shr    $0x9,%eax
80106e72:	a3 6c 14 19 80       	mov    %eax,0x8019146c
}
80106e77:	c3                   	ret
80106e78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e7f:	00 

80106e80 <ideintr>:
// Interrupt handler.
void
ideintr(void)
{
  // no-op
}
80106e80:	c3                   	ret
80106e81:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e88:	00 
80106e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e90 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	53                   	push   %ebx
80106e94:	83 ec 10             	sub    $0x10,%esp
80106e97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uchar *p;

  if(!holdingsleep(&b->lock))
80106e9a:	8d 43 0c             	lea    0xc(%ebx),%eax
80106e9d:	50                   	push   %eax
80106e9e:	e8 bd d1 ff ff       	call   80104060 <holdingsleep>
80106ea3:	83 c4 10             	add    $0x10,%esp
80106ea6:	85 c0                	test   %eax,%eax
80106ea8:	0f 84 9b 00 00 00    	je     80106f49 <iderw+0xb9>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80106eae:	8b 13                	mov    (%ebx),%edx
80106eb0:	89 d0                	mov    %edx,%eax
80106eb2:	83 e0 06             	and    $0x6,%eax
80106eb5:	83 f8 02             	cmp    $0x2,%eax
80106eb8:	0f 84 7e 00 00 00    	je     80106f3c <iderw+0xac>
    panic("iderw: nothing to do");
  if(b->dev != 1)
80106ebe:	83 7b 04 01          	cmpl   $0x1,0x4(%ebx)
80106ec2:	75 6b                	jne    80106f2f <iderw+0x9f>
    panic("iderw: request not for disk 1");
  if(b->blockno >= disksize)
80106ec4:	8b 43 08             	mov    0x8(%ebx),%eax
80106ec7:	3b 05 6c 14 19 80    	cmp    0x8019146c,%eax
80106ecd:	73 53                	jae    80106f22 <iderw+0x92>
    panic("iderw: block out of range");

  p = memdisk + b->blockno*BSIZE;
80106ecf:	c1 e0 09             	shl    $0x9,%eax
80106ed2:	03 05 68 14 19 80    	add    0x80191468,%eax

  if(b->flags & B_DIRTY){
80106ed8:	f6 c2 04             	test   $0x4,%dl
80106edb:	75 23                	jne    80106f00 <iderw+0x70>
    b->flags &= ~B_DIRTY;
    memmove(p, b->data, BSIZE);
  } else
    memmove(b->data, p, BSIZE);
80106edd:	83 ec 04             	sub    $0x4,%esp
80106ee0:	68 00 02 00 00       	push   $0x200
80106ee5:	50                   	push   %eax
80106ee6:	8d 43 5c             	lea    0x5c(%ebx),%eax
80106ee9:	50                   	push   %eax
80106eea:	e8 41 d5 ff ff       	call   80104430 <memmove>
80106eef:	83 c4 10             	add    $0x10,%esp
  b->flags |= B_VALID;
80106ef2:	83 0b 02             	orl    $0x2,(%ebx)
}
80106ef5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106ef8:	c9                   	leave
80106ef9:	c3                   	ret
80106efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    b->flags &= ~B_DIRTY;
80106f00:	83 e2 fb             	and    $0xfffffffb,%edx
    memmove(p, b->data, BSIZE);
80106f03:	83 ec 04             	sub    $0x4,%esp
    b->flags &= ~B_DIRTY;
80106f06:	89 13                	mov    %edx,(%ebx)
    memmove(p, b->data, BSIZE);
80106f08:	8d 53 5c             	lea    0x5c(%ebx),%edx
80106f0b:	68 00 02 00 00       	push   $0x200
80106f10:	52                   	push   %edx
80106f11:	50                   	push   %eax
80106f12:	e8 19 d5 ff ff       	call   80104430 <memmove>
80106f17:	83 c4 10             	add    $0x10,%esp
  b->flags |= B_VALID;
80106f1a:	83 0b 02             	orl    $0x2,(%ebx)
}
80106f1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106f20:	c9                   	leave
80106f21:	c3                   	ret
    panic("iderw: block out of range");
80106f22:	83 ec 0c             	sub    $0xc,%esp
80106f25:	68 41 74 10 80       	push   $0x80107441
80106f2a:	e8 51 94 ff ff       	call   80100380 <panic>
    panic("iderw: request not for disk 1");
80106f2f:	83 ec 0c             	sub    $0xc,%esp
80106f32:	68 23 74 10 80       	push   $0x80107423
80106f37:	e8 44 94 ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80106f3c:	83 ec 0c             	sub    $0xc,%esp
80106f3f:	68 0e 74 10 80       	push   $0x8010740e
80106f44:	e8 37 94 ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80106f49:	83 ec 0c             	sub    $0xc,%esp
80106f4c:	68 f8 73 10 80       	push   $0x801073f8
80106f51:	e8 2a 94 ff ff       	call   80100380 <panic>
