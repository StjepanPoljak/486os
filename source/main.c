#define VIDEO_MEMORY 0xb8000
#define WHITE_ON_BLACK 0x0f

int var;

int strlen(const char* str) {
	int i = 0;
	while (str[i++] != '\0') {}
	return i;
}

void kmain() {

	int *vga = (int*)VIDEO_MEMORY;
	const char* test_msg = "Welcome to the wonderful world of C! Please be my guest and enjoy my operating system!";
	int i = 0;

	if (var != 0) return;

	while (i < strlen(test_msg)) {
		*(vga + i) = test_msg[i] | 0x0f00;
		i++;
	}

	while (1) {

	}
}
