source-directory=`pwd`
src=$(source-directory)/pomodoro.sh
target-directory=~/.local/bin
target=$(target-directory)/pomodoro.sh

install: clean
	mkdir -p $(target-directory)
	ln -s $(src) $(target)
clean:
	rm -f $(target)

.PHONY: install clean

