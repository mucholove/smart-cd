#import <Foundation/Foundation.h>


// How does fish command completion work
// https://unicode-table.com/en/sets/arrow-symbols/

/*
▲
▼
ᐁ

> cdd

	Go to directory...
	
		Recently visited...
		-------------------
		~/ThirdDraftMyFramework/GNUstepWorkspace
		/etc/Headers
		/etc/GNUstep/Headers
		---
		View complete history...
		
		Favorites...
		-------------------
		~/ThirdDraft/KNNFramework/GNUstepWorkspace
		/etc/Headers
		/etc/GNUstep/Headers
		---
		[Favorites] [Collection] [Collection] [Collection]	
*/
		
// https://www.gnu.org/software/libc/manual/html_node/Environment-Access.html#Environment-Access

/*
	// https://stackoverflow.com/questions/17976289/executing-shell-commands-with-nstask-objective-c-cocoa
	// https://developer.apple.com/documentation/foundation/nstask/1415808-waituntilexit?language=objc
	/*
	The NSTask object converts both path and 
	the strings in arguments to appropriate C-style 
	strings (using fileSystemRepresentation) before 
	passing them to the task via argv[] .
	 The strings in arguments do not undergo shell expansion, 
	so you do not need to do special quoting, 
	and shell variables, such as $PWD, are not resolved.
	*/
	
	NSString* path = [[[NSProcessInfo processInfo]environment]objectForKey:@"PATH"];
	// NSString *envVarString = @(getenv("__MY_ENV_NAME__"));

	NSTask *task = [[NSTask alloc] init];
	
	[task setLaunchPath:@"/bin/bash"];
	
	[task setArguments:@[ @"-c", @"/usr/bin/killall Dock" ]];
	
	// [task setStandarError:anNSPipe];
	// [task setStandarError:anNSFileHandle];
	
	[task launch];
	
	[task waitUntilExit];
	
	int status = [task terminationStatus];
 
	if (status == 0) {
		NSLog(@"Task succeeded.");
	} else {
		NSLog(@"Task failed.");
	}
*/	
		
		
		
		

int main(int argc, char *argv[]) {
	Shell *invokingShell
		= [CurrentEnv currentShell];
		
	NSData *dirChooser
		= [DirChooser readOrCreateFileAtPath:"~/.chooseDir"];
	
	DirChooser *dirChooser
		= [[DirChooser alloc] initWithFile:@"File"];
		
	DirChooserCursor *cursor
		= [dirChooser cursor];
	
	@autoreleasepool {
		while (c = getchar())
			if (c == '\n')
			{
				DirChooseRow *dirChooserRow = [cursor objectUnder];
				
				if ([dirChooserRow isKindOfClass:[DirectoryRepRow class])
				{
					DirectoryRepRow *dirRepRow = (DirectoryRepRow*)dirChooserRow;
					
					NSString *directoryPath = [dirRepRow directory];
					
					[invokingShell runCommand:[NSString stringWithFormat:@"cd %@", directoryPath]];
					
					exit(0);
				}
			}
			if (c == '\esc')
			{
				exit(0);
			}
		
	}
}