# I/O Forwarding Explorer - Figures (output)

In this directory, you can find the generated PDF files of plots:

- `figure-2.pdf`

Figure 2 depicts the bandwidth measured at the client-side in the MareNostrum 4 supercomputer when multiple clients issue their requests following each access pattern and considering the number of available I/O nodes (0, 1, 2, 4, and 8). Each experiment was repeated at least five times, in random order, and spanning different days and periods of the day. The y-axis is not the same.

- `figure-2-complete.pdf` (additional plot)

This additional plot includes the results for all the 189 access patterns and configurations we tested in MareNostrum 4 supercomputer. Due to the large size of this plot, it was not included in our manuscript. For each access pattern, we explored a different number of available I/O nodes (0, 1, 2, 4, and 8). Each experiment was repeated at least five times, in random order, and spanning different days and periods of the day. The y-axis is not the same.

- `figure-3-a.pdf`

Figure 3 (a) illustrates how many options an allocation policy would have to consider. For 88 (~46%) of the patterns, three possible choices would impact performance.

- `figure-3-b.pdf`

Figure 3 (b) depicts the optimal number of I/O nodes for each of the 189 scenarios, considering the available choices of I/O nodes, is different. For 12 (6%), 83 (44%), 15 (8%), and 17 (9%) scenarios, the largest bandwidth is achieved by using 1, 2, 4, and 8 I/O nodes respectively. Whereas, for 62 scenarios (33%), not using forwarding is the best alternative.

- `figure-4.pdf`

We conducted a smaller test on Santos Dumont (due to allocation restrictions) comprised of eight patterns described in Table 2 of our manuscript. Figure 4 depicts the I/O bandwidth of distinct write access patterns with varying I/O nodes. One can notice that the forwarding layer setup's impact is not the same on MareNostrum and Santos Dumont. A common behavior observed in Santos Dumont is that using more I/O nodes yields better performance. Regardless, the choice of using forwarding or not in this machine is still relevant. For instance, for the scenarios A, B, H, and V, direct access to the Lustre PFS translates into higher I/O bandwidth. Whereas, for some other scenarios, the benefits of using forwarding are perceived by the application after more than one I/O node is available. It is possible to notice that using a single I/O node is not the best choice for none of the tested patterns. If two were available, scenarios C, E, O, T, and W would already see benefits. For G, I, J, K, L, M, N, Q, S, U, and X, only when four I/O nodes are given to the application, in this machine, performance would increase. Other patterns, such as F, R, and V, require eight I/O nodes instead to achieve the best performance.